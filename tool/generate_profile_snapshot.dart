import 'dart:convert';
import 'dart:io';

import 'package:profile/features/profile/config/profile_config.dart';
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';

const _snapshotOutputPath = 'assets/data/profile_snapshot.json';

/// Generates the static profile snapshot used by GitHub Pages deployments.
///
/// This exists because Flutter Web bundles are public browser code. A GitHub
/// token must never be shipped in Flutter code, generated assets, or config
/// files. Run this tool from a trusted environment instead, such as GitHub
/// Actions with GITHUB_TOKEN or a local shell with an exported token, then let
/// the web app read the generated JSON asset at runtime.
Future<void> main() async {
  final token = Platform.environment['GITHUB_TOKEN'];

  if (token == null || token.trim().isEmpty) {
    stderr.writeln(
      'Missing GITHUB_TOKEN. Run as: '
      'GITHUB_TOKEN=xxx dart run tool/generate_profile_snapshot.dart',
    );
    exitCode = 64;
    return;
  }

  final client = _GitHubClient(token: token.trim());
  final generator = _ProfileSnapshotGenerator(
    client: client,
    outputFile: File(_snapshotOutputPath),
  );

  try {
    await generator.generate();
  } on Object catch (error) {
    stderr.writeln('[snapshot] Failed: $error');
    exitCode = 1;
  } finally {
    client.close();
  }
}

class _ProfileSnapshotGenerator {
  const _ProfileSnapshotGenerator({
    required _GitHubClient client,
    required File outputFile,
  }) : _client = client,
       _outputFile = outputFile;

  final _GitHubClient _client;
  final File _outputFile;

  Future<void> generate() async {
    stdout.writeln(
      '[snapshot] Generating GitHub snapshot for ${ProfileConfig.githubLogin}',
    );

    final generatedAt = DateTime.now().toUtc();
    final userResult = await _fetchGitHubUser(ProfileConfig.githubLogin);
    final repositories = <String, Object?>{};
    final repositoryConfigs = [...ProfileConfig.repositories]
      ..sort(_compareRepositoryConfig);

    for (final config in repositoryConfigs) {
      final key = _repositoryKey(config);
      if (repositories.containsKey(key)) {
        throw StateError('Duplicate repository snapshot key: $key');
      }

      stdout.writeln(
        '[snapshot] Processing repository $key '
        '(${config.owner}/${config.repo})',
      );

      final snapshot = await _fetchRepositorySnapshot(config);
      repositories[key] = snapshot;

      final errors = snapshot['errors'];
      if (errors is List && errors.isNotEmpty) {
        stdout.writeln(
          '[snapshot] Repository $key completed with ${errors.length} issue(s)',
        );
      } else {
        stdout.writeln('[snapshot] Repository $key succeeded');
      }
    }

    final snapshot = <String, Object?>{
      'schemaVersion': 1,
      'generatedAt': generatedAt.toIso8601String(),
      'githubUser': userResult.value == null
          ? <String, Object?>{
              'login': ProfileConfig.githubLogin,
              'error': userResult.error,
            }
          : _githubUserToJson(
              login: ProfileConfig.githubLogin,
              stats: userResult.value!,
            ),
      'repositories': repositories,
    };

    await _outputFile.parent.create(recursive: true);
    await _outputFile.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(snapshot)}\n',
    );

    await _validateSnapshotFile(_outputFile);
    stdout.writeln('[snapshot] Wrote ${_outputFile.path}');
  }

  Future<_FetchResult<GitHubUserStats>> _fetchGitHubUser(String login) async {
    final response = await _client.get(
      Uri.https('api.github.com', '/users/$login'),
      label: 'user $login',
    );

    if (!response.isOk) {
      return _FetchResult.failure(
        'GitHub user request failed with HTTP ${response.statusCode}',
      );
    }

    final json = response.jsonObject;
    if (json == null) {
      return const _FetchResult.failure(
        'GitHub user response was not a JSON object',
      );
    }

    return _FetchResult.success(
      GitHubUserStats(
        publicRepos: _asInt(json['public_repos']),
        followers: _asInt(json['followers']),
        following: _asInt(json['following']),
        updatedAt: _asDate(json['updated_at']),
      ),
    );
  }

  Future<Map<String, Object?>> _fetchRepositorySnapshot(
    ProfileRepositoryConfig config,
  ) async {
    final ref = GitHubRepositoryRef(owner: config.owner, name: config.repo);
    final errors = <String>[];
    final repoResult = await _fetchRepositoryMetadata(ref);

    if (repoResult.error != null) {
      errors.add(repoResult.error!);
    }

    final repoJson = repoResult.value;
    var languages = const <String>[];
    int? totalCommits;
    int? contributorCommits;

    if (repoJson != null) {
      final languagesResult = await _fetchRepositoryLanguages(ref);
      if (languagesResult.error == null) {
        languages = languagesResult.value!;
      } else {
        errors.add(languagesResult.error!);
      }

      final totalCommitsResult = await _fetchCommitCount(ref);
      if (totalCommitsResult.error == null) {
        totalCommits = totalCommitsResult.value;
      } else {
        errors.add(totalCommitsResult.error!);
      }

      final contributorCommitsResult = await _fetchContributorCommits(
        ref,
        ProfileConfig.githubLogin,
      );
      if (contributorCommitsResult.error == null) {
        contributorCommits = contributorCommitsResult.value;
      } else {
        errors.add(contributorCommitsResult.error!);
      }
    }

    return <String, Object?>{
      'status': errors.isEmpty
          ? 'ok'
          : repoJson == null
          ? 'failed'
          : 'partial',
      'owner': config.owner,
      'name': config.repo,
      'displayName': config.displayName,
      'url': config.url,
      'order': config.order,
      'stars': _asInt(repoJson?['stargazers_count']),
      'forks': _asInt(repoJson?['forks_count']),
      'topics': _asStringList(repoJson?['topics']),
      'languages': languages,
      'totalCommits': totalCommits,
      'contributor': ProfileConfig.githubLogin,
      'contributorCommits': contributorCommits,
      if (errors.isNotEmpty) 'errors': errors,
    };
  }

  Future<_FetchResult<Map<String, dynamic>>> _fetchRepositoryMetadata(
    GitHubRepositoryRef ref,
  ) async {
    final response = await _client.get(
      Uri.https('api.github.com', '/repos/${ref.owner}/${ref.name}'),
      label: 'repository ${ref.owner}/${ref.name}',
    );

    if (!response.isOk) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: repository request failed with '
        'HTTP ${response.statusCode}',
      );
    }

    final json = response.jsonObject;
    if (json == null) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: repository response was not a JSON object',
      );
    }

    return _FetchResult.success(json);
  }

  Future<_FetchResult<List<String>>> _fetchRepositoryLanguages(
    GitHubRepositoryRef ref,
  ) async {
    final response = await _client.get(
      Uri.https('api.github.com', '/repos/${ref.owner}/${ref.name}/languages'),
      label: 'languages ${ref.owner}/${ref.name}',
    );

    if (!response.isOk) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: languages request failed with '
        'HTTP ${response.statusCode}',
      );
    }

    final json = response.jsonObject;
    if (json == null) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: languages response was not a JSON object',
      );
    }

    return _FetchResult.success(json.keys.take(4).toList(growable: false));
  }

  Future<_FetchResult<int>> _fetchCommitCount(GitHubRepositoryRef ref) async {
    final response = await _client.get(
      Uri.https('api.github.com', '/repos/${ref.owner}/${ref.name}/commits', {
        'per_page': '1',
      }),
      label: 'commits ${ref.owner}/${ref.name}',
    );

    if (!response.isOk) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: commit count request failed with '
        'HTTP ${response.statusCode}',
      );
    }

    final totalFromLink = _lastPageFromLinkHeader(response.headers['link']);
    if (totalFromLink != null) return _FetchResult.success(totalFromLink);

    final json = response.jsonArray;
    if (json == null) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: commit count response was not a JSON array',
      );
    }

    return _FetchResult.success(json.length);
  }

  Future<_FetchResult<int>> _fetchContributorCommits(
    GitHubRepositoryRef ref,
    String contributorLogin,
  ) async {
    final response = await _client.get(
      Uri.https(
        'api.github.com',
        '/repos/${ref.owner}/${ref.name}/contributors',
        {'per_page': '100'},
      ),
      label: 'contributors ${ref.owner}/${ref.name}',
    );

    if (!response.isOk) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: contributors request failed with '
        'HTTP ${response.statusCode}',
      );
    }

    final json = response.jsonArray;
    if (json == null) {
      return _FetchResult.failure(
        '${ref.owner}/${ref.name}: contributors response was not a JSON array',
      );
    }

    for (final contributor in json.whereType<Map<String, dynamic>>()) {
      final login = contributor['login'];
      if (login is String &&
          login.toLowerCase() == contributorLogin.toLowerCase()) {
        return _FetchResult.success(_asInt(contributor['contributions']) ?? 0);
      }
    }

    return const _FetchResult.success(0);
  }

  Map<String, Object?> _githubUserToJson({
    required String login,
    required GitHubUserStats stats,
  }) {
    return <String, Object?>{
      'login': login,
      'publicRepos': stats.publicRepos,
      'followers': stats.followers,
      'following': stats.following,
      'updatedAt': stats.updatedAt?.toUtc().toIso8601String(),
    };
  }

  Future<void> _validateSnapshotFile(File file) async {
    if (!await file.exists()) {
      throw StateError('Snapshot file was not created: ${file.path}');
    }

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map) {
      throw StateError('Snapshot root must be a JSON object');
    }

    final repositories = decoded['repositories'];
    if (repositories is! Map || repositories.isEmpty) {
      throw StateError('Snapshot repositories section must not be empty');
    }
  }

  static int _compareRepositoryConfig(
    ProfileRepositoryConfig a,
    ProfileRepositoryConfig b,
  ) {
    final order = a.order.compareTo(b.order);
    if (order != 0) return order;
    return a.displayName.compareTo(b.displayName);
  }

  static String _repositoryKey(ProfileRepositoryConfig config) {
    return config.displayName;
  }
}

class _GitHubClient {
  _GitHubClient({required String token}) : _token = token;

  final String _token;
  final HttpClient _client = HttpClient();

  Future<_GitHubResponse> get(Uri uri, {required String label}) async {
    stdout.writeln('[github] GET ${uri.path}${_query(uri)} ($label)');

    try {
      final request = await _client.getUrl(uri);
      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/vnd.github+json',
      );
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_token');
      request.headers.set('X-GitHub-Api-Version', '2022-11-28');
      request.headers.set(HttpHeaders.userAgentHeader, 'profile-snapshot-tool');

      final response = await request.close();
      final body = await utf8.decodeStream(response);
      final headers = <String, String>{};
      response.headers.forEach((name, values) {
        headers[name.toLowerCase()] = values.join(', ');
      });

      final result = _GitHubResponse(
        statusCode: response.statusCode,
        headers: headers,
        body: body,
      );

      stdout.writeln('[github] $label -> HTTP ${result.statusCode}');
      _logRateLimit(result.headers);

      if (!result.isOk) {
        stderr.writeln('[github] $label failed body: ${_bodyPreview(body)}');
      }

      return result;
    } on IOException catch (error) {
      stderr.writeln('[github] $label failed before response: $error');
      return _GitHubResponse(
        statusCode: 0,
        headers: const {},
        body: error.toString(),
      );
    }
  }

  void close() {
    _client.close(force: true);
  }

  void _logRateLimit(Map<String, String> headers) {
    final remaining = headers['x-ratelimit-remaining'];
    final limit = headers['x-ratelimit-limit'];
    final reset = _formatRateLimitReset(headers['x-ratelimit-reset']);

    if (remaining == null && limit == null && reset == null) return;

    stdout.writeln(
      '[github] rate limit remaining=${remaining ?? '?'}'
      '/${limit ?? '?'} reset=${reset ?? '?'}',
    );
  }

  static String _query(Uri uri) {
    return uri.hasQuery ? '?${uri.query}' : '';
  }

  static String _bodyPreview(String body) {
    const maxLength = 1200;
    if (body.length <= maxLength) return body;
    return '${body.substring(0, maxLength)}...';
  }

  static String? _formatRateLimitReset(String? value) {
    if (value == null) return null;

    final seconds = int.tryParse(value);
    if (seconds == null) return value;

    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    ).toIso8601String();
  }
}

class _GitHubResponse {
  const _GitHubResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
  });

  final int statusCode;
  final Map<String, String> headers;
  final String body;

  bool get isOk => statusCode == HttpStatus.ok;

  Map<String, dynamic>? get jsonObject {
    final decoded = _decodeJson();
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return decoded.cast<String, dynamic>();
    return null;
  }

  List<dynamic>? get jsonArray {
    final decoded = _decodeJson();
    return decoded is List ? decoded : null;
  }

  Object? _decodeJson() {
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }
}

class _FetchResult<T> {
  const _FetchResult.success(this.value) : error = null;

  const _FetchResult.failure(this.error) : value = null;

  final T? value;
  final String? error;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _asDate(Object? value) {
  return value is String ? DateTime.tryParse(value) : null;
}

List<String> _asStringList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}

int? _lastPageFromLinkHeader(String? linkHeader) {
  if (linkHeader == null) return null;

  for (final part in linkHeader.split(',').map((part) => part.trim())) {
    if (!part.endsWith('rel="last"')) continue;

    final match = RegExp(r'[?&]page=(\d+)>').firstMatch(part);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  return null;
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<GitHubUserStats?> fetchGitHubUser(String login) async {
    return _guard(() async {
      // TODO(github-pages): Flutter Web must not contain GitHub tokens or
      // secrets. Direct browser calls to the GitHub API use the unauthenticated
      // rate limit and can fail after several reloads. For production on
      // GitHub Pages, generate assets/data/profile_snapshot.json in GitHub
      // Actions with GITHUB_TOKEN, then have Flutter read that asset instead
      // of making live GitHub API requests.
      final uri = Uri.https('api.github.com', '/users/$login');

      _log('GET $uri');

      final response = await _client.get(uri, headers: _githubHeaders);

      _logResponse(
        operation: 'fetchGitHubUser',
        requestUrl: uri,
        response: response,
      );

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      return GitHubUserStats(
        publicRepos: _asInt(json['public_repos']),
        followers: _asInt(json['followers']),
        following: _asInt(json['following']),
        updatedAt: _asDate(json['updated_at']),
      );
    });
  }

  Future<CodeforcesUserStats?> fetchCodeforcesUser(String handle) async {
    return _guard(() async {
      final uri = Uri.https('codeforces.com', '/api/user.info', {
        'handles': handle,
      });

      _log('GET $uri');

      final response = await _client.get(uri);

      _logResponse(
        operation: 'fetchCodeforcesUser',
        requestUrl: uri,
        response: response,
      );

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'];

      if (result is! List || result.isEmpty) {
        _log('Codeforces result is empty or invalid');
        return null;
      }

      final first = result.first;

      if (first is! Map<String, dynamic>) {
        _log('Codeforces user object has invalid type');
        return null;
      }

      return CodeforcesUserStats(
        rating: _asInt(first['rating']),
        maxRating: _asInt(first['maxRating']),
        rank: first['rank'] as String?,
        contribution: _asInt(first['contribution']),
        city: first['city'] as String?,
        organization: first['organization'] as String?,
      );
    });
  }

  Future<LeetCodeUserStats?> fetchLeetCodeUser(String username) async {
    return _guard(() async {
      final uri = Uri.https(
        'leetcode-api-faisalshohag.vercel.app',
        '/$username',
      );

      _log('GET $uri');

      final response = await _client.get(uri);

      _logResponse(
        operation: 'fetchLeetCodeUser',
        requestUrl: uri,
        response: response,
      );

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;

      return LeetCodeUserStats(
        totalSolved: _asInt(json['totalSolved']),
        easySolved: _asInt(json['easySolved']),
        mediumSolved: _asInt(json['mediumSolved']),
        hardSolved: _asInt(json['hardSolved']),
        ranking: _asInt(json['ranking']),
      );
    });
  }

  Future<GitHubRepositoryStats?> fetchGitHubRepository({
    required GitHubRepositoryRef ref,
    required String contributorLogin,
  }) async {
    return _guard(() async {
      final uri = Uri.https(
        'api.github.com',
        '/repos/${ref.owner}/${ref.name}',
      );

      _log('GET $uri');

      final repoResponse = await _client.get(uri, headers: _githubHeaders);

      _logResponse(
        operation: 'fetchGitHubRepository',
        requestUrl: uri,
        response: repoResponse,
      );

      if (repoResponse.statusCode != 200) return null;

      final repoJson = jsonDecode(repoResponse.body) as Map<String, dynamic>;

      final repoTopics = (repoJson['topics'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(growable: false);

      final results = await Future.wait([
        _fetchRepositoryLanguages(ref),
        _fetchCommitCount(ref),
        _fetchContributorCommits(ref, contributorLogin),
      ]);

      _log('''
Repository metrics:
repo=${ref.owner}/${ref.name}
languages=${results[0]}
totalCommits=${results[1]}
authorCommits=${results[2]}
''');

      return GitHubRepositoryStats(
        totalCommits: results[1] as int?,
        authorCommits: results[2] as int?,
        stars: _asInt(repoJson['stargazers_count']),
        forks: _asInt(repoJson['forks_count']),
        topics: repoTopics,
        languages: results[0] as List<String>,
      );
    });
  }

  Future<GitHubSearchStats?> searchGitHubRepositories(String query) async {
    return _guard(() async {
      final uri = Uri.https('api.github.com', '/search/repositories', {
        'q': query,
        'per_page': '1',
      });

      _log('GET $uri');

      final response = await _client.get(uri, headers: _githubHeaders);

      _logResponse(
        operation: 'searchGitHubRepositories',
        requestUrl: uri,
        response: response,
      );

      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = json['items'];

      Map<String, dynamic>? firstItem;

      if (items is List && items.isNotEmpty) {
        final first = items.first;
        if (first is Map<String, dynamic>) {
          firstItem = first;
        }
      }

      return GitHubSearchStats(
        totalCount: _asInt(json['total_count']),
        firstRepositoryName: firstItem?['full_name'] as String?,
        firstRepositoryUrl: firstItem?['html_url'] as String?,
      );
    });
  }

  Future<List<String>> _fetchRepositoryLanguages(
    GitHubRepositoryRef ref,
  ) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/${ref.owner}/${ref.name}/languages',
    );

    _log('GET $uri');

    final response = await _client.get(uri, headers: _githubHeaders);

    _logResponse(
      operation: '_fetchRepositoryLanguages',
      requestUrl: uri,
      response: response,
    );

    if (response.statusCode != 200) return const [];

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    return json.keys.take(4).toList(growable: false);
  }

  Future<int?> _fetchCommitCount(GitHubRepositoryRef ref) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/${ref.owner}/${ref.name}/commits',
      {'per_page': '1'},
    );

    _log('GET $uri');

    final response = await _client.get(uri, headers: _githubHeaders);

    _logResponse(
      operation: '_fetchCommitCount',
      requestUrl: uri,
      response: response,
    );

    if (response.statusCode != 200) return null;

    final link = response.headers['link'];

    _log('Commit link header: $link');

    final totalFromLink = _lastPageFromLinkHeader(link);
    if (totalFromLink != null) return totalFromLink;

    final json = jsonDecode(response.body);
    return json is List ? json.length : null;
  }

  Future<int?> _fetchContributorCommits(
    GitHubRepositoryRef ref,
    String contributorLogin,
  ) async {
    final uri = Uri.https(
      'api.github.com',
      '/repos/${ref.owner}/${ref.name}/contributors',
      {'per_page': '100'},
    );

    _log('GET $uri');

    final response = await _client.get(uri, headers: _githubHeaders);

    _logResponse(
      operation: '_fetchContributorCommits',
      requestUrl: uri,
      response: response,
    );

    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);
    if (json is! List) return null;

    for (final contributor in json.whereType<Map<String, dynamic>>()) {
      final login = contributor['login'];

      if (login is String &&
          login.toLowerCase() == contributorLogin.toLowerCase()) {
        _log(
          'Matched contributor: $login, commits=${contributor['contributions']}',
        );
        return _asInt(contributor['contributions']);
      }
    }

    _log('Contributor $contributorLogin not found in ${ref.owner}/${ref.name}');

    return 0;
  }

  void _logResponse({
    required String operation,
    required Uri requestUrl,
    required http.Response response,
  }) {
    _log('''
[$operation]
REQUEST URL: $requestUrl
STATUS: ${response.statusCode}
GITHUB RATE LIMIT HEADERS:
x-ratelimit-remaining: ${response.headers['x-ratelimit-remaining']}
x-ratelimit-limit: ${response.headers['x-ratelimit-limit']}
x-ratelimit-reset: ${response.headers['x-ratelimit-reset']}

BODY:
${response.body}
''');
  }

  int? _lastPageFromLinkHeader(String? linkHeader) {
    if (linkHeader == null) return null;

    String? lastLink;

    for (final part in linkHeader.split(',').map((part) => part.trim())) {
      if (part.endsWith('rel="last"')) {
        lastLink = part;
        break;
      }
    }

    if (lastLink == null) return null;

    final match = RegExp(r'[?&]page=(\d+)>').firstMatch(lastLink);
    return match == null ? null : int.tryParse(match.group(1)!);
  }

  Future<T?> _guard<T>(Future<T?> Function() operation) async {
    try {
      return await operation();
    } catch (e, st) {
      _log('''
ERROR:
$e

STACKTRACE:
$st
''');

      return null;
    }
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);

    _log('Failed to parse int from value: $value');

    return null;
  }

  DateTime? _asDate(Object? value) {
    if (value is! String) {
      _log('Failed to parse date from value: $value');
      return null;
    }

    return DateTime.tryParse(value);
  }

  void _log(String message) {
    debugPrint('[ProfileRemoteDataSource] $message');
  }

  static const _githubHeaders = {
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };
}

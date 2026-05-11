import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<GitHubUserStats?> fetchGitHubUser(String login) async {
    return _guard(() async {
      final response = await _client.get(
        Uri.https('api.github.com', '/users/$login'),
        headers: _githubHeaders,
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
      final response = await _client.get(
        Uri.https('codeforces.com', '/api/user.info', {'handles': handle}),
      );
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final result = json['result'];
      if (result is! List || result.isEmpty) return null;

      final user = result.first as Map<String, dynamic>;
      return CodeforcesUserStats(
        rating: _asInt(user['rating']),
        maxRating: _asInt(user['maxRating']),
        rank: user['rank'] as String?,
        contribution: _asInt(user['contribution']),
        city: user['city'] as String?,
        organization: user['organization'] as String?,
      );
    });
  }

  Future<LeetCodeUserStats?> fetchLeetCodeUser(String username) async {
    return _guard(() async {
      final response = await _client.get(
        Uri.https('leetcode-api-faisalshohag.vercel.app', '/$username'),
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
      final repoResponse = await _client.get(
        Uri.https('api.github.com', '/repos/${ref.owner}/${ref.name}'),
        headers: _githubHeaders,
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
      final response = await _client.get(
        Uri.https('api.github.com', '/search/repositories', {
          'q': query,
          'per_page': '1',
        }),
        headers: _githubHeaders,
      );
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final items = json['items'];
      Map<String, dynamic>? firstItem;
      if (items is List && items.isNotEmpty) {
        firstItem = items.first as Map<String, dynamic>;
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
    final response = await _client.get(
      Uri.https('api.github.com', '/repos/${ref.owner}/${ref.name}/languages'),
      headers: _githubHeaders,
    );
    if (response.statusCode != 200) return const [];

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return json.keys.take(4).toList(growable: false);
  }

  Future<int?> _fetchCommitCount(GitHubRepositoryRef ref) async {
    final response = await _client.get(
      Uri.https('api.github.com', '/repos/${ref.owner}/${ref.name}/commits', {
        'per_page': '1',
      }),
      headers: _githubHeaders,
    );
    if (response.statusCode != 200) return null;

    final link = response.headers['link'];
    final totalFromLink = _lastPageFromLinkHeader(link);
    if (totalFromLink != null) return totalFromLink;

    final json = jsonDecode(response.body);
    return json is List ? json.length : null;
  }

  Future<int?> _fetchContributorCommits(
    GitHubRepositoryRef ref,
    String contributorLogin,
  ) async {
    final response = await _client.get(
      Uri.https(
        'api.github.com',
        '/repos/${ref.owner}/${ref.name}/contributors',
      ),
      headers: _githubHeaders,
    );
    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);
    if (json is! List) return null;

    for (final contributor in json.whereType<Map<String, dynamic>>()) {
      final login = contributor['login'];
      if (login is String &&
          login.toLowerCase() == contributorLogin.toLowerCase()) {
        return _asInt(contributor['contributions']);
      }
    }
    return 0;
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
    } catch (_) {
      return null;
    }
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  DateTime? _asDate(Object? value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }

  static const _githubHeaders = {'Accept': 'application/vnd.github+json'};
}

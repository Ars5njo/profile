import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';

const profileSnapshotAssetPath = 'assets/data/profile_snapshot.json';

class ProfileSnapshotDataSource {
  const ProfileSnapshotDataSource({
    AssetBundle? assetBundle,
    String assetPath = profileSnapshotAssetPath,
  }) : _assetBundle = assetBundle,
       _assetPath = assetPath;

  final AssetBundle? _assetBundle;
  final String _assetPath;

  Future<ProfileSnapshot?> loadSnapshot() async {
    try {
      final rawJson = await (_assetBundle ?? rootBundle).loadString(_assetPath);
      final decoded = jsonDecode(rawJson);

      if (decoded is! Map) {
        _log('Snapshot parse failure: root JSON value is not an object');
        return null;
      }

      final snapshot = ProfileSnapshot.fromJson(
        decoded.cast<String, dynamic>(),
      );

      if (!snapshot.hasGitHubSnapshotContent) {
        _log('Snapshot does not contain GitHub data');
        return null;
      }

      _log(
        'Snapshot loaded: generatedAt=${snapshot.generatedAtIsoString}, '
        'repositories=${snapshot.repositories.length}',
      );

      return snapshot;
    } on Object catch (error, stackTrace) {
      _log('''
Snapshot parse failure:
$error

STACKTRACE:
$stackTrace
''');
      return null;
    }
  }

  void _log(String message) {
    debugPrint('[ProfileSnapshotDataSource] $message');
  }
}

class ProfileSnapshot {
  const ProfileSnapshot({
    required this.generatedAt,
    required this.githubUser,
    required this.repositories,
  });

  factory ProfileSnapshot.fromJson(Map<String, dynamic> json) {
    final github = _asObject(json['github']);
    final githubUserJson =
        _asObject(json['githubUser']) ??
        (github == null ? null : _asObject(github['user']));
    final repositoriesJson = json['repositories'] ?? github?['repositories'];

    return ProfileSnapshot(
      generatedAt: _asDate(json['generatedAt']),
      githubUser: githubUserJson == null
          ? null
          : GitHubUserSnapshot.fromJson(githubUserJson),
      repositories: Map.unmodifiable(_parseRepositories(repositoriesJson)),
    );
  }

  final DateTime? generatedAt;
  final GitHubUserSnapshot? githubUser;
  final Map<String, GitHubRepositorySnapshot> repositories;

  bool get hasGitHubSnapshotContent =>
      githubUser != null || repositories.isNotEmpty;

  String get generatedAtIsoString => generatedAt?.toIso8601String() ?? 'n/a';

  GitHubUserStats? get githubUserStats => githubUser?.toStats();

  GitHubRepositoryStats? repositoryStatsFor({
    required String displayName,
    required GitHubRepositoryRef ref,
  }) {
    final snapshot = repositorySnapshotFor(displayName: displayName, ref: ref);
    return snapshot?.toStats();
  }

  GitHubRepositorySnapshot? repositorySnapshotFor({
    required String displayName,
    required GitHubRepositoryRef ref,
  }) {
    final byDisplayName = repositories[displayName];
    if (byDisplayName != null) return byDisplayName;

    for (final repository in repositories.values) {
      if (repository.matches(ref)) return repository;
    }

    return null;
  }

  static Map<String, GitHubRepositorySnapshot> _parseRepositories(
    Object? value,
  ) {
    final repositories = <String, GitHubRepositorySnapshot>{};

    if (value is Map) {
      for (final entry in value.entries) {
        final repositoryJson = _asObject(entry.value);
        if (repositoryJson == null) continue;

        final repository = GitHubRepositorySnapshot.fromJson(
          repositoryJson,
          fallbackDisplayName: entry.key.toString(),
        );
        repositories[repository.key] = repository;
      }
    } else if (value is List) {
      for (final item in value) {
        final repositoryJson = _asObject(item);
        if (repositoryJson == null) continue;

        final repository = GitHubRepositorySnapshot.fromJson(repositoryJson);
        repositories[repository.key] = repository;
      }
    }

    return repositories;
  }
}

class GitHubUserSnapshot {
  const GitHubUserSnapshot({
    required this.login,
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.updatedAt,
    this.error,
  });

  factory GitHubUserSnapshot.fromJson(Map<String, dynamic> json) {
    return GitHubUserSnapshot(
      login: _asString(json['login']),
      publicRepos: _asInt(json['publicRepos']) ?? _asInt(json['public_repos']),
      followers: _asInt(json['followers']),
      following: _asInt(json['following']),
      updatedAt: _asDate(json['updatedAt']) ?? _asDate(json['updated_at']),
      error: _asString(json['error']),
    );
  }

  final String? login;
  final int? publicRepos;
  final int? followers;
  final int? following;
  final DateTime? updatedAt;
  final String? error;

  GitHubUserStats toStats() {
    return GitHubUserStats(
      publicRepos: publicRepos,
      followers: followers,
      following: following,
      updatedAt: updatedAt,
    );
  }
}

class GitHubRepositorySnapshot {
  const GitHubRepositorySnapshot({
    required this.status,
    required this.owner,
    required this.name,
    required this.displayName,
    required this.url,
    required this.order,
    required this.stars,
    required this.forks,
    required this.topics,
    required this.languages,
    required this.totalCommits,
    required this.contributor,
    required this.contributorCommits,
    required this.errors,
  });

  factory GitHubRepositorySnapshot.fromJson(
    Map<String, dynamic> json, {
    String? fallbackDisplayName,
  }) {
    final owner = _asString(json['owner']);
    final name = _asString(json['name']) ?? _asString(json['repo']);
    final displayName =
        _asString(json['displayName']) ??
        fallbackDisplayName ??
        name ??
        owner ??
        '';

    return GitHubRepositorySnapshot(
      status: _asString(json['status']),
      owner: owner,
      name: name,
      displayName: displayName,
      url: _asString(json['url']) ?? _fallbackUrl(owner, name),
      order: _asInt(json['order']),
      stars: _asInt(json['stars']) ?? _asInt(json['stargazers_count']),
      forks: _asInt(json['forks']) ?? _asInt(json['forks_count']),
      topics: List.unmodifiable(_asStringList(json['topics'])),
      languages: List.unmodifiable(_asStringList(json['languages'])),
      totalCommits: _asInt(json['totalCommits']),
      contributor: _asString(json['contributor']),
      contributorCommits:
          _asInt(json['contributorCommits']) ?? _asInt(json['authorCommits']),
      errors: List.unmodifiable(_asStringList(json['errors'])),
    );
  }

  final String? status;
  final String? owner;
  final String? name;
  final String displayName;
  final String? url;
  final int? order;
  final int? stars;
  final int? forks;
  final List<String> topics;
  final List<String> languages;
  final int? totalCommits;
  final String? contributor;
  final int? contributorCommits;
  final List<String> errors;

  String get key =>
      displayName.isNotEmpty ? displayName : '${owner ?? ''}/$name';

  bool matches(GitHubRepositoryRef ref) {
    return owner?.toLowerCase() == ref.owner.toLowerCase() &&
        name?.toLowerCase() == ref.name.toLowerCase();
  }

  GitHubRepositoryStats toStats() {
    return GitHubRepositoryStats(
      totalCommits: totalCommits,
      authorCommits: contributorCommits,
      stars: stars,
      forks: forks,
      topics: topics,
      languages: languages,
    );
  }

  static String? _fallbackUrl(String? owner, String? name) {
    if (owner == null || name == null) return null;
    return 'https://github.com/$owner/$name';
  }
}

Map<String, dynamic>? _asObject(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.cast<String, dynamic>();
  return null;
}

String? _asString(Object? value) {
  if (value is String && value.trim().isNotEmpty) return value;
  return null;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _asDate(Object? value) {
  if (value is! String || value.trim().isEmpty) return null;
  return DateTime.tryParse(value);
}

List<String> _asStringList(Object? value) {
  if (value is! List) return const [];
  return value.whereType<String>().toList(growable: false);
}

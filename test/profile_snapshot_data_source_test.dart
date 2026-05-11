import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/features/profile/data/datasources/profile_snapshot_data_source.dart';
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';

void main() {
  test('loads generated GitHub snapshot asset into typed stats', () async {
    final dataSource = ProfileSnapshotDataSource(
      assetBundle: _StringAssetBundle({
        profileSnapshotAssetPath: _generatedSnapshotJson,
      }),
    );

    final snapshot = await dataSource.loadSnapshot();

    expect(snapshot, isNotNull);
    expect(snapshot!.generatedAt, DateTime.parse('2026-05-01T10:20:30.000Z'));
    expect(snapshot.githubUserStats?.publicRepos, 42);
    expect(snapshot.githubUserStats?.followers, 7);

    final stats = snapshot.repositoryStatsFor(
      displayName: 'tiktok-book',
      ref: const GitHubRepositoryRef(owner: 'Ars5njo', name: 'tiktok-book'),
    );

    expect(stats?.totalCommits, 123);
    expect(stats?.authorCommits, 45);
    expect(stats?.stars, 3);
    expect(stats?.topics, ['flutter', 'reader']);
    expect(stats?.languages, ['Dart']);
  });

  test('returns null when snapshot has no GitHub content', () async {
    final dataSource = ProfileSnapshotDataSource(
      assetBundle: _StringAssetBundle({
        profileSnapshotAssetPath: '''
{
  "generatedAt": null,
  "github": {
    "user": null,
    "repositories": []
  }
}
''',
      }),
    );

    expect(await dataSource.loadSnapshot(), isNull);
  });
}

class _StringAssetBundle extends CachingAssetBundle {
  _StringAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];
    if (value == null) {
      throw StateError('Unable to load asset: $key');
    }

    final bytes = Uint8List.fromList(utf8.encode(value));
    return ByteData.view(bytes.buffer);
  }
}

const _generatedSnapshotJson = '''
{
  "schemaVersion": 1,
  "generatedAt": "2026-05-01T10:20:30.000Z",
  "githubUser": {
    "login": "Ars5njo",
    "publicRepos": 42,
    "followers": 7,
    "following": 5,
    "updatedAt": "2026-04-30T12:00:00.000Z"
  },
  "repositories": {
    "tiktok-book": {
      "status": "ok",
      "owner": "Ars5njo",
      "name": "tiktok-book",
      "displayName": "tiktok-book",
      "url": "https://github.com/Ars5njo/tiktok-book",
      "order": 0,
      "stars": 3,
      "forks": 1,
      "topics": ["flutter", "reader"],
      "languages": ["Dart"],
      "totalCommits": 123,
      "contributor": "Ars5njo",
      "contributorCommits": 45
    }
  }
}
''';

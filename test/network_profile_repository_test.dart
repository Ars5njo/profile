import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:profile/features/profile/config/profile_config.dart';
import 'package:profile/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:profile/features/profile/data/datasources/profile_snapshot_data_source.dart';
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';
import 'package:profile/features/profile/data/profile_repository.dart';
import 'package:profile/l10n/app_localizations_en.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  test('snapshot mode does not call GitHub remote methods', () async {
    final remoteDataSource = _FakeRemoteDataSource(failOnGitHub: true);
    final snapshotDataSource = _FakeSnapshotDataSource(_profileSnapshot());
    final repository = NetworkProfileRepository(
      remoteDataSource: remoteDataSource,
      snapshotDataSource: snapshotDataSource,
      useSnapshot: true,
    );

    final profile = await repository.loadProfile(AppLocalizationsEn());

    expect(snapshotDataSource.loadCalls, 1);
    expect(remoteDataSource.githubUserCalls, 0);
    expect(remoteDataSource.githubRepositoryCalls, 0);
    expect(remoteDataSource.codeforcesCalls, 1);
    expect(remoteDataSource.leetCodeCalls, 1);
    expect(profile.heroMetrics.first.value, '8');
    expect(profile.updatedAtLabel, contains('May 1, 2026'));
  });

  test('snapshot failure falls back to live GitHub API flow', () async {
    final remoteDataSource = _FakeRemoteDataSource();
    final snapshotDataSource = _FakeSnapshotDataSource(null);
    final repository = NetworkProfileRepository(
      remoteDataSource: remoteDataSource,
      snapshotDataSource: snapshotDataSource,
      useSnapshot: true,
    );

    await repository.loadProfile(AppLocalizationsEn());

    expect(snapshotDataSource.loadCalls, 1);
    expect(remoteDataSource.githubUserCalls, 1);
    expect(
      remoteDataSource.githubRepositoryCalls,
      ProfileConfig.repositories.length,
    );
    expect(remoteDataSource.codeforcesCalls, 1);
    expect(remoteDataSource.leetCodeCalls, 1);
  });

  test('live mode bypasses snapshot datasource', () async {
    final remoteDataSource = _FakeRemoteDataSource();
    final snapshotDataSource = _FakeSnapshotDataSource(_profileSnapshot());
    final repository = NetworkProfileRepository(
      remoteDataSource: remoteDataSource,
      snapshotDataSource: snapshotDataSource,
      useSnapshot: false,
    );

    await repository.loadProfile(AppLocalizationsEn());

    expect(snapshotDataSource.loadCalls, 0);
    expect(remoteDataSource.githubUserCalls, 1);
    expect(
      remoteDataSource.githubRepositoryCalls,
      ProfileConfig.repositories.length,
    );
    expect(remoteDataSource.codeforcesCalls, 1);
    expect(remoteDataSource.leetCodeCalls, 1);
  });
}

class _FakeSnapshotDataSource extends ProfileSnapshotDataSource {
  _FakeSnapshotDataSource(this.snapshot);

  final ProfileSnapshot? snapshot;
  int loadCalls = 0;

  @override
  Future<ProfileSnapshot?> loadSnapshot() async {
    loadCalls++;
    return snapshot;
  }
}

class _FakeRemoteDataSource extends ProfileRemoteDataSource {
  _FakeRemoteDataSource({this.failOnGitHub = false});

  final bool failOnGitHub;
  int githubUserCalls = 0;
  int githubRepositoryCalls = 0;
  int codeforcesCalls = 0;
  int leetCodeCalls = 0;

  @override
  Future<GitHubUserStats?> fetchGitHubUser(String login) async {
    githubUserCalls++;
    if (failOnGitHub) {
      fail('GitHub user API should not be called in snapshot mode');
    }

    return const GitHubUserStats(
      publicRepos: 13,
      followers: 5,
      following: 4,
      updatedAt: null,
    );
  }

  @override
  Future<GitHubRepositoryStats?> fetchGitHubRepository({
    required GitHubRepositoryRef ref,
    required String contributorLogin,
  }) async {
    githubRepositoryCalls++;
    if (failOnGitHub) {
      fail('GitHub repository API should not be called in snapshot mode');
    }

    return const GitHubRepositoryStats(
      totalCommits: 21,
      authorCommits: 9,
      stars: 1,
      forks: 0,
      topics: ['live'],
      languages: ['Dart'],
    );
  }

  @override
  Future<CodeforcesUserStats?> fetchCodeforcesUser(String handle) async {
    codeforcesCalls++;
    return const CodeforcesUserStats(
      rating: 744,
      maxRating: 755,
      rank: 'newbie',
      contribution: 0,
      city: 'Innopolis',
      organization: 'Innopolis University',
    );
  }

  @override
  Future<LeetCodeUserStats?> fetchLeetCodeUser(String username) async {
    leetCodeCalls++;
    return const LeetCodeUserStats(
      totalSolved: 100,
      easySolved: 50,
      mediumSolved: 40,
      hardSolved: 10,
      ranking: 12345,
    );
  }
}

ProfileSnapshot _profileSnapshot() {
  return ProfileSnapshot(
    generatedAt: DateTime.utc(2026, 5, 1, 10, 20, 30),
    githubUser: GitHubUserSnapshot(
      login: ProfileConfig.githubLogin,
      publicRepos: 8,
      followers: 3,
      following: 2,
      updatedAt: DateTime.utc(2026, 4, 30, 12),
    ),
    repositories: {
      ProfileConfig.tiktokBookRepository.displayName:
          const GitHubRepositorySnapshot(
            status: 'ok',
            owner: 'Ars5njo',
            name: 'tiktok-book',
            displayName: 'tiktok-book',
            url: 'https://github.com/Ars5njo/tiktok-book',
            order: 0,
            stars: 3,
            forks: 1,
            topics: ['flutter', 'reader'],
            languages: ['Dart'],
            totalCommits: 123,
            contributor: 'Ars5njo',
            contributorCommits: 45,
            errors: [],
          ),
    },
  );
}

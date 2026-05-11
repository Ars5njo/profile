import 'package:intl/intl.dart';
import 'package:profile/features/profile/config/profile_config.dart';
import 'package:profile/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:profile/features/profile/data/models/remote_profile_stats.dart';
import 'package:profile/features/profile/domain/entities/coding_profile.dart';
import 'package:profile/features/profile/domain/entities/contact_link.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/domain/entities/portfolio_project.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';
import 'package:profile/l10n/app_localizations.dart';

abstract class ProfileRepository {
  Future<DeveloperProfile> loadProfile(AppLocalizations l10n);
}

class NetworkProfileRepository implements ProfileRepository {
  NetworkProfileRepository({ProfileRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<DeveloperProfile> loadProfile(AppLocalizations l10n) async {
    final githubUserFuture = _remoteDataSource.fetchGitHubUser(
      ProfileConfig.githubLogin,
    );
    final codeforcesFuture = _remoteDataSource.fetchCodeforcesUser(
      ProfileConfig.codeforcesHandle,
    );
    final leetCodeFuture = _remoteDataSource.fetchLeetCodeUser(
      ProfileConfig.leetCodeUsername,
    );
    final repoStatsFuture = Future.wait(
      _repoSpecs.map(
        (spec) => _remoteDataSource.fetchGitHubRepository(
          ref: spec.ref,
          contributorLogin: ProfileConfig.githubLogin,
        ),
      ),
    );

    final githubUser = await githubUserFuture;
    final codeforces = await codeforcesFuture;
    final leetCode = await leetCodeFuture;
    final repoStats = await repoStatsFuture;

    final repoStatsByName = <String, GitHubRepositoryStats?>{
      for (var i = 0; i < _repoSpecs.length; i++)
        _repoSpecs[i].config.displayName: repoStats[i],
    };
    final orderedRepoSpecs = [..._repoSpecs]
      ..sort((a, b) => a.config.order.compareTo(b.config.order));

    return DeveloperProfile(
      fullName: l10n.fullName,
      age: l10n.ageValue,
      role: l10n.role,
      location: l10n.location,
      avatarAssetPath: ProfileConfig.avatarAssetPath,
      summary: l10n.summary,
      about: [l10n.aboutParagraph1, l10n.aboutParagraph2, l10n.aboutParagraph3],
      heroMetrics: _buildHeroMetrics(l10n, githubUser, codeforces, leetCode),
      contacts: _buildContacts(l10n),
      codingProfiles: _buildCodingProfiles(
        l10n,
        githubUser,
        codeforces,
        leetCode,
      ),
      projects: [
        for (final spec in orderedRepoSpecs)
          _buildRepositoryProject(
            l10n,
            spec,
            repoStatsByName[spec.config.displayName],
          ),
      ],
      updatedAtLabel: l10n.publicSnapshot(_formatDate(l10n, DateTime.now())),
    );
  }

  List<ProfileMetric> _buildHeroMetrics(
    AppLocalizations l10n,
    GitHubUserStats? github,
    CodeforcesUserStats? codeforces,
    LeetCodeUserStats? leetCode,
  ) {
    return [
      ProfileMetric(
        label: l10n.githubRepos,
        value: _formatInt(l10n, github?.publicRepos),
        caption: l10n.public,
      ),
      ProfileMetric(
        label: l10n.codeforces,
        value: _formatInt(l10n, codeforces?.rating),
        caption: l10n.rating.toLowerCase(),
      ),
      ProfileMetric(
        label: l10n.leetcode,
        value: _formatInt(l10n, leetCode?.totalSolved),
        caption: l10n.solved.toLowerCase(),
      ),
      ProfileMetric(
        label: l10n.city,
        value: _textOrNA(l10n, codeforces?.city),
        caption: l10n.cfProfile,
      ),
    ];
  }

  List<ContactLink> _buildContacts(AppLocalizations l10n) {
    return [
      ContactLink(
        label: ProfileConfig.telegramContact.label,
        value: ProfileConfig.telegramContact.value,
        icon: ProfileConfig.telegramContact.icon,
        url: ProfileConfig.telegramContact.url,
        note: l10n.telegramNote,
      ),
      ContactLink(
        label: ProfileConfig.emailContact.label,
        value: ProfileConfig.emailContact.value,
        icon: ProfileConfig.emailContact.icon,
        note: l10n.emailNote,
      ),
      ContactLink(
        label: ProfileConfig.githubContact.label,
        value: ProfileConfig.githubContact.value,
        icon: ProfileConfig.githubContact.icon,
        url: ProfileConfig.githubContact.url,
      ),
    ];
  }

  List<CodingProfile> _buildCodingProfiles(
    AppLocalizations l10n,
    GitHubUserStats? github,
    CodeforcesUserStats? codeforces,
    LeetCodeUserStats? leetCode,
  ) {
    final codeforcesRank = _textOrNA(l10n, codeforces?.rank);
    final codeforcesOrganization = _textOrNA(l10n, codeforces?.organization);

    return [
      CodingProfile(
        platform: ProfileConfig.githubSocial.platform,
        handle: ProfileConfig.githubSocial.handle,
        url: ProfileConfig.githubSocial.url,
        headline: l10n.githubHeadline,
        accent: ProfileAccent.teal,
        metrics: [
          ProfileMetric(
            label: l10n.publicRepos,
            value: _formatInt(l10n, github?.publicRepos),
          ),
          ProfileMetric(
            label: l10n.followers,
            value: _formatInt(l10n, github?.followers),
          ),
          ProfileMetric(
            label: l10n.following,
            value: _formatInt(l10n, github?.following),
          ),
          ProfileMetric(
            label: l10n.updated,
            value: _formatDate(l10n, github?.updatedAt),
          ),
        ],
      ),
      CodingProfile(
        platform: ProfileConfig.codeforcesSocial.platform,
        handle: ProfileConfig.codeforcesSocial.handle,
        url: ProfileConfig.codeforcesSocial.url,
        headline: l10n.codeforcesHeadline(
          codeforcesRank,
          codeforcesOrganization,
        ),
        accent: ProfileAccent.coral,
        metrics: [
          ProfileMetric(
            label: l10n.rating,
            value: _formatInt(l10n, codeforces?.rating),
          ),
          ProfileMetric(
            label: l10n.maxRating,
            value: _formatInt(l10n, codeforces?.maxRating),
          ),
          ProfileMetric(label: l10n.rank, value: codeforcesRank),
          ProfileMetric(
            label: l10n.contribution,
            value: _formatInt(l10n, codeforces?.contribution),
          ),
        ],
      ),
      CodingProfile(
        platform: ProfileConfig.leetCodeSocial.platform,
        handle: ProfileConfig.leetCodeSocial.handle,
        url: ProfileConfig.leetCodeSocial.url,
        headline: l10n.leetcodeHeadline(
          _formatInt(l10n, leetCode?.totalSolved),
        ),
        accent: ProfileAccent.amber,
        metrics: [
          ProfileMetric(
            label: l10n.solved,
            value: _formatInt(l10n, leetCode?.totalSolved),
          ),
          ProfileMetric(
            label: l10n.easy,
            value: _formatInt(l10n, leetCode?.easySolved),
          ),
          ProfileMetric(
            label: l10n.medium,
            value: _formatInt(l10n, leetCode?.mediumSolved),
          ),
          ProfileMetric(
            label: l10n.ranking,
            value: _formatInt(l10n, leetCode?.ranking),
          ),
        ],
      ),
    ];
  }

  PortfolioProject _buildRepositoryProject(
    AppLocalizations l10n,
    _RepositoryProjectSpec spec,
    GitHubRepositoryStats? stats,
  ) {
    final taxonomy = stats == null
        ? l10n.notAvailable
        : stats.topics.isNotEmpty
            ? stats.topics.take(2).join(' / ')
            : stats.languages.isNotEmpty
                ? stats.languages.take(2).join(' / ')
                : l10n.notAvailable;

    return PortfolioProject(
      name: spec.config.displayName,
      logoText: spec.config.logoText,
      url: spec.config.url,
      description: spec.description(l10n),
      role: spec.role(l10n),
      accent: spec.config.accent,
      stack: [
        ...spec.config.personalStack,
        for (final language in stats?.languages ?? const <String>[])
          if (!spec.config.personalStack.contains(language)) language,
      ],
      metrics: [
        ProfileMetric(
          label: l10n.repoCommits,
          value: _formatInt(l10n, stats?.totalCommits),
        ),
        ProfileMetric(
          label: l10n.myCommits,
          value: _formatInt(l10n, stats?.authorCommits),
        ),
        ProfileMetric(
          label: stats != null && stats.topics.isNotEmpty
              ? l10n.topics
              : l10n.languages,
          value: taxonomy,
        ),
      ],
      sourceNote: l10n.apiSource,
    );
  }

  String _formatInt(AppLocalizations l10n, int? value) {
    if (value == null) return l10n.notAvailable;
    return NumberFormat.decimalPattern(l10n.localeName).format(value);
  }

  String _formatDate(AppLocalizations l10n, DateTime? value) {
    if (value == null) return l10n.notAvailable;
    return DateFormat.yMMMd(l10n.localeName).format(value.toLocal());
  }

  String _textOrNA(AppLocalizations l10n, String? value) {
    if (value == null || value.trim().isEmpty) return l10n.notAvailable;
    return value;
  }

  static final _repoSpecs = [
    _RepositoryProjectSpec(
      config: ProfileConfig.tiktokBookRepository,
      description: (l10n) => l10n.tiktokDescription,
      role: (l10n) => l10n.tiktokRole,
    ),
    _RepositoryProjectSpec(
      config: ProfileConfig.loadBalancerRepository,
      description: (l10n) => l10n.tiktokDescription,
      role: (l10n) => l10n.tiktokRole,
    ),
    _RepositoryProjectSpec(
      config: ProfileConfig.vrataRepository,
      description: (l10n) => l10n.vrataDescription,
      role: (l10n) => l10n.vrataRole,
    ),
    _RepositoryProjectSpec(
      config: ProfileConfig.mdUiKitRepository,
      description: (l10n) => l10n.uiKitDescription,
      role: (l10n) => l10n.uiKitRole,
    ),
    _RepositoryProjectSpec(
      config: ProfileConfig.tatarShowerRepository,
      description: (l10n) => l10n.tatarDescription,
      role: (l10n) => l10n.tatarRole,
    ),
  ];
}

class _RepositoryProjectSpec {
  const _RepositoryProjectSpec({
    required this.config,
    required this.description,
    required this.role,
  });

  final ProfileRepositoryConfig config;
  final String Function(AppLocalizations l10n) description;
  final String Function(AppLocalizations l10n) role;

  GitHubRepositoryRef get ref =>
      GitHubRepositoryRef(owner: config.owner, name: config.repo);
}

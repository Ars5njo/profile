import 'package:intl/intl.dart';
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
    final githubUserFuture = _remoteDataSource.fetchGitHubUser(_githubLogin);
    final codeforcesFuture = _remoteDataSource.fetchCodeforcesUser(
      _codeforcesHandle,
    );
    final leetCodeFuture = _remoteDataSource.fetchLeetCodeUser(
      _leetCodeUsername,
    );
    final repoStatsFuture = Future.wait(
      _repoSpecs.map(
        (spec) => _remoteDataSource.fetchGitHubRepository(
          ref: spec.ref,
          contributorLogin: _githubLogin,
        ),
      ),
    );

    final githubUser = await githubUserFuture;
    final codeforces = await codeforcesFuture;
    final leetCode = await leetCodeFuture;
    final repoStats = await repoStatsFuture;

    final repoStatsByName = <String, GitHubRepositoryStats?>{
      for (var i = 0; i < _repoSpecs.length; i++)
        _repoSpecs[i].name: repoStats[i],
    };

    return DeveloperProfile(
      fullName: l10n.fullName,
      age: l10n.ageValue,
      role: l10n.role,
      location: l10n.location,
      avatarAssetPath: 'assets/images/arsen_latipov.jpeg',
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
        for (final spec in _repoSpecs)
          _buildRepositoryProject(l10n, spec, repoStatsByName[spec.name]),
      ]..sort((a, b) => _projectOrder(a.name).compareTo(_projectOrder(b.name))),
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
        label: 'Telegram',
        value: '@Ars5njo',
        icon: 'telegram',
        url: 'https://t.me/Ars5njo',
        note: l10n.telegramNote,
      ),
      ContactLink(
        label: 'Email',
        value: l10n.emailValue,
        icon: 'mail',
        note: l10n.emailNote,
      ),
      ContactLink(
        label: 'GitHub',
        value: l10n.githubContactValue,
        icon: 'github',
        url: 'https://github.com/$_githubLogin',
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
        platform: 'GitHub',
        handle: _githubLogin,
        url: 'https://github.com/$_githubLogin',
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
        platform: 'Codeforces',
        handle: _codeforcesHandle,
        url: 'https://codeforces.com/profile/$_codeforcesHandle',
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
        platform: 'LeetCode',
        handle: _leetCodeUsername,
        url: 'https://leetcode.com/u/$_leetCodeUsername/',
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
      name: spec.name,
      logoText: spec.logoText,
      url: spec.ref.url,
      description: spec.description(l10n),
      role: spec.role(l10n),
      accent: spec.accent,
      stack: [
        ...spec.personalStack,
        for (final language in stats?.languages ?? const <String>[])
          if (!spec.personalStack.contains(language)) language,
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

  int _projectOrder(String projectName) {
    return switch (projectName) {
      'tiktok-book' => 0,
      'load-balancer' => 1,
      'VRATA' => 2,
      'md_ui_kit' => 3,
      'tatar-shower-app-flutter-go' => 4,
      _ => 99,
    };
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

  static const _githubLogin = 'Ars5njo';
  static const _codeforcesHandle = 'Ars5nj0';
  static const _leetCodeUsername = 'Ars5njo';

  static final _repoSpecs = [
    _RepositoryProjectSpec(
      name: 'tiktok-book',
      logoText: 'TB',
      ref: const GitHubRepositoryRef(owner: 'Ars5njo', name: 'tiktok-book'),
      accent: ProfileAccent.teal,
      personalStack: const ['Flutter', 'Dart', 'Widgetbook'],
      description: (l10n) => l10n.tiktokDescription,
      role: (l10n) => l10n.tiktokRole,
    ),
    _RepositoryProjectSpec(
      name: 'load-balancer',
      logoText: 'LB',
      ref: const GitHubRepositoryRef(owner: 'SNA-RATA', name: 'load-balancer'),
      accent: ProfileAccent.teal,
      personalStack: const ['Flutter', 'Dart', 'REST API'],
      description: (l10n) => l10n.tiktokDescription,
      role: (l10n) => l10n.tiktokRole,
    ),
    _RepositoryProjectSpec(
      name: 'VRATA',
      logoText: 'VR',
      ref: const GitHubRepositoryRef(owner: 'Messenger-DNP', name: 'VRATA'),
      accent: ProfileAccent.violet,
      personalStack: const [
        'Flutter',
        'Dart',
        'Riverpod',
        'REST API',
        'WebSocket/STOMP',
      ],
      description: (l10n) => l10n.vrataDescription,
      role: (l10n) => l10n.vrataRole,
    ),
    _RepositoryProjectSpec(
      name: 'md_ui_kit',
      logoText: 'MD',
      ref: const GitHubRepositoryRef(
        owner: 'Miracle-Development',
        name: 'md_ui_kit',
      ),
      accent: ProfileAccent.coral,
      personalStack: const ['Flutter', 'Dart', 'Storybook', 'Stories', 'Knobs'],
      description: (l10n) => l10n.uiKitDescription,
      role: (l10n) => l10n.uiKitRole,
    ),
    _RepositoryProjectSpec(
      name: 'tatar-shower-app-flutter-go',
      logoText: 'TS',
      ref: const GitHubRepositoryRef(
        owner: 'Ars5njo',
        name: 'tatar-shower-app-flutter-go',
      ),
      accent: ProfileAccent.amber,
      personalStack: const ['Flutter', 'Dart'],
      description: (l10n) => l10n.tatarDescription,
      role: (l10n) => l10n.tatarRole,
    ),
  ];
}

class _RepositoryProjectSpec {
  const _RepositoryProjectSpec({
    required this.name,
    required this.logoText,
    required this.ref,
    required this.accent,
    required this.personalStack,
    required this.description,
    required this.role,
  });

  final String name;
  final String logoText;
  final GitHubRepositoryRef ref;
  final ProfileAccent accent;
  final List<String> personalStack;
  final String Function(AppLocalizations l10n) description;
  final String Function(AppLocalizations l10n) role;
}

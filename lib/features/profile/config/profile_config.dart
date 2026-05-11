import 'package:profile/features/profile/domain/entities/coding_profile.dart';

class ProfileConfig {
  const ProfileConfig._();

  static const githubLogin = 'Ars5njo';
  static const codeforcesHandle = 'Ars5nj0';
  static const leetCodeUsername = 'Ars5njo';

  static const telegramUsername = '@Ars5njo';
  static const telegramUrl = 'https://t.me/Ars5njo';

  static const emailValue = 'busyars5njo@gmail.com';

  static const githubContactValue = 'github.com/Ars5njo';
  static const githubContactUrl = 'https://github.com/Ars5njo';
  static const codeforcesProfileUrl = 'https://codeforces.com/profile/Ars5nj0';
  static const leetCodeProfileUrl = 'https://leetcode.com/u/Ars5njo/';

  static const avatarAssetPath = 'assets/images/arsen_latipov.jpeg';

  static const telegramContact = ProfileContactConfig(
    label: 'Telegram',
    value: telegramUsername,
    icon: 'telegram',
    url: telegramUrl,
  );

  static const emailContact = ProfileContactConfig(
    label: 'Email',
    value: emailValue,
    icon: 'mail',
  );

  static const githubContact = ProfileContactConfig(
    label: 'GitHub',
    value: githubContactValue,
    icon: 'github',
    url: githubContactUrl,
  );

  static const githubSocial = ProfileSocialConfig(
    platform: 'GitHub',
    handle: githubLogin,
    url: githubContactUrl,
  );

  static const codeforcesSocial = ProfileSocialConfig(
    platform: 'Codeforces',
    handle: codeforcesHandle,
    url: codeforcesProfileUrl,
  );

  static const leetCodeSocial = ProfileSocialConfig(
    platform: 'LeetCode',
    handle: leetCodeUsername,
    url: leetCodeProfileUrl,
  );

  static const tiktokBookRepository = ProfileRepositoryConfig(
    displayName: 'tiktok-book',
    logoText: 'TB',
    owner: 'Ars5njo',
    repo: 'tiktok-book',
    order: 0,
    accent: ProfileAccent.teal,
    personalStack: ['Flutter', 'Dart', 'Widgetbook'],
  );

  static const loadBalancerRepository = ProfileRepositoryConfig(
    displayName: 'load-balancer',
    logoText: 'LB',
    owner: 'SNA-RATA',
    repo: 'load-balancer',
    order: 2,
    accent: ProfileAccent.teal,
    personalStack: ['Flutter', 'Dart', 'REST API'],
  );

  static const vrataRepository = ProfileRepositoryConfig(
    displayName: 'VRATA',
    logoText: 'VR',
    owner: 'Messenger-DNP',
    repo: 'VRATA',
    order: 3,
    accent: ProfileAccent.violet,
    personalStack: [
      'Flutter',
      'Dart',
      'Riverpod',
      'REST API',
      'WebSocket/STOMP',
    ],
  );

  static const mdUiKitRepository = ProfileRepositoryConfig(
    displayName: 'md_ui_kit',
    logoText: 'MD',
    owner: 'Miracle-Development',
    repo: 'md_ui_kit',
    order: 1,
    accent: ProfileAccent.coral,
    personalStack: ['Flutter', 'Dart', 'Storybook', 'Stories', 'Knobs'],
  );

  static const tatarShowerRepository = ProfileRepositoryConfig(
    displayName: 'tatar-shower-app-flutter-go',
    logoText: 'TS',
    owner: 'Ars5njo',
    repo: 'tatar-shower-app-flutter-go',
    order: 4,
    accent: ProfileAccent.amber,
    personalStack: ['Flutter', 'Dart'],
  );

  static const repositories = [
    tiktokBookRepository,
    loadBalancerRepository,
    vrataRepository,
    mdUiKitRepository,
    tatarShowerRepository,
  ];
}

class ProfileContactConfig {
  const ProfileContactConfig({
    required this.label,
    required this.value,
    required this.icon,
    this.url,
  });

  final String label;
  final String value;
  final String icon;
  final String? url;
}

class ProfileSocialConfig {
  const ProfileSocialConfig({
    required this.platform,
    required this.handle,
    required this.url,
  });

  final String platform;
  final String handle;
  final String url;
}

class ProfileRepositoryConfig {
  const ProfileRepositoryConfig({
    required this.displayName,
    required this.logoText,
    required this.owner,
    required this.repo,
    required this.order,
    required this.accent,
    required this.personalStack,
  });

  final String displayName;
  final String logoText;
  final String owner;
  final String repo;
  final int order;
  final ProfileAccent accent;
  final List<String> personalStack;

  String get url => 'https://github.com/$owner/$repo';
}

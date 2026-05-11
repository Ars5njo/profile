// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Arsen Latipov';

  @override
  String get navHome => 'Home';

  @override
  String get navProfiles => 'Profiles';

  @override
  String get navProjects => 'Projects';

  @override
  String get navContacts => 'Contacts';

  @override
  String get contactButton => 'Contact';

  @override
  String get languageRu => 'RU';

  @override
  String get languageEn => 'EN';

  @override
  String get loadingProfile => 'Loading live profile metrics';

  @override
  String get loadingHint =>
      'Fetching GitHub, Codeforces, LeetCode, and repository commits.';

  @override
  String get retry => 'Retry';

  @override
  String get loadErrorTitle => 'Could not load profile';

  @override
  String get loadErrorBody =>
      'The page is ready, but one of the network sources failed before the profile was assembled.';

  @override
  String get fullName => 'Arsen Latipov';

  @override
  String get role => 'Flutter Developer';

  @override
  String get location => 'Innopolis, Russia';

  @override
  String get ageValue => '19';

  @override
  String ageChip(Object age) {
    return 'Age: $age';
  }

  @override
  String get summary => 'TBD';

  @override
  String publicSnapshot(Object date) {
    return 'Live snapshot: $date';
  }

  @override
  String get aboutTitle => 'About me';

  @override
  String get aboutSubtitle => 'TBD';

  @override
  String get aboutParagraph1 => ' TBD';

  @override
  String get aboutParagraph2 => 'TBD';

  @override
  String get aboutParagraph3 => 'TBD';

  @override
  String get codingProfilesTitle => 'Coding profiles';

  @override
  String get codingProfilesSubtitle =>
      'Live public metrics from GitHub, Codeforces, and LeetCode. Each card links to the original profile.';

  @override
  String get projectsTitle => 'Projects';

  @override
  String get projectsSubtitle =>
      'Project cards focus on role, personal stack, repository stats, and commit counts fetched from GitHub APIs.';

  @override
  String get contactsTitle => 'Contacts';

  @override
  String get contactsSubtitle =>
      'Direct links for messaging and source profiles.';

  @override
  String get footer =>
      'Built with Flutter Web, l10n, live APIs, and feature-first architecture.';

  @override
  String get telegramNote => 'Public handle';

  @override
  String get emailValue => 'add email';

  @override
  String get emailNote => 'Not published in public profiles';

  @override
  String get githubContactValue => 'github.com/Ars5njo';

  @override
  String get githubHeadline => 'Arsen Latipov, public profile';

  @override
  String codeforcesHeadline(Object rank, Object organization) {
    return '$rank, $organization';
  }

  @override
  String leetcodeHeadline(Object count) {
    return '$count accepted problems';
  }

  @override
  String openPlatform(Object platform) {
    return 'Open $platform';
  }

  @override
  String get repository => 'Repository';

  @override
  String get notAvailable => 'n/a';

  @override
  String get notFound => 'not found';

  @override
  String get manual => 'manual';

  @override
  String get publicRepos => 'Public repos';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get updated => 'Updated';

  @override
  String get rating => 'Rating';

  @override
  String get maxRating => 'Max rating';

  @override
  String get rank => 'Rank';

  @override
  String get contribution => 'Contribution';

  @override
  String get solved => 'Solved';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get ranking => 'Ranking';

  @override
  String get githubRepos => 'GitHub repos';

  @override
  String get public => 'public';

  @override
  String get codeforces => 'Codeforces';

  @override
  String get leetcode => 'LeetCode';

  @override
  String get city => 'City';

  @override
  String get cfProfile => 'CF profile';

  @override
  String get repoCommits => 'Repo commits';

  @override
  String get myCommits => 'My commits';

  @override
  String get languages => 'Languages';

  @override
  String get topics => 'Topics';

  @override
  String get stars => 'Stars';

  @override
  String get publicRepo => 'Public repo';

  @override
  String get stats => 'Stats';

  @override
  String get roleMetric => 'Role';

  @override
  String get frontend => 'frontend';

  @override
  String get apiSource => 'GitHub API';

  @override
  String get githubSearchSource => 'GitHub Search API';

  @override
  String get repoNotFoundNote =>
      'GitHub Search API did not find a public load-balancer repository for this profile.';

  @override
  String get tiktokDescription =>
      'Offline reader for PDF/TXT books with RSVP mode, bionic text, local library and progress saving.';

  @override
  String get tiktokRole =>
      'Flutter feature work: reading flow, UI states, local data and project structure.';

  @override
  String get loadBalancerDescription =>
      'Project about distributing incoming traffic between backend nodes: balancing algorithms, health checks, and service resilience.';

  @override
  String get loadBalancerRole =>
      'Public repository was not found; stack and contribution need manual confirmation.';

  @override
  String get vrataDescription =>
      'Distributed room-based messenger with isolated Kafka topics, persistent history, and WebSocket/STOMP realtime delivery.';

  @override
  String get vrataRole =>
      'Frontend role: Flutter Web client, feature-first layers, room/chat UI, and API integration.';

  @override
  String get uiKitDescription =>
      'Miracle Development UI kit: reusable Flutter widgets, themed components, story scenarios, and golden-testing workflow.';

  @override
  String get uiKitRole =>
      'Core contributor: components, stories, exports, theme support, and package maintenance.';

  @override
  String get tatarDescription =>
      'Cold shower habit app with Flutter frontend, Go backend, PostgreSQL schema, and DevOps automation.';

  @override
  String get tatarRole =>
      'Frontend Developer: auth flow, schedule editor, timer, dashboard states, and adaptive Flutter screens.';
}

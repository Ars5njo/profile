import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Arsen Latipov'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProfiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get navProfiles;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get navContacts;

  /// No description provided for @contactButton.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactButton;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'RU'**
  String get languageRu;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageEn;

  /// No description provided for @loadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Loading live profile metrics'**
  String get loadingProfile;

  /// No description provided for @loadingHint.
  ///
  /// In en, this message translates to:
  /// **'Fetching GitHub, Codeforces, LeetCode, and repository commits.'**
  String get loadingHint;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load profile'**
  String get loadErrorTitle;

  /// No description provided for @loadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'The page is ready, but one of the network sources failed before the profile was assembled.'**
  String get loadErrorBody;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Arsen Latipov'**
  String get fullName;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Flutter Developer'**
  String get role;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Innopolis, Russia'**
  String get location;

  /// No description provided for @ageValue.
  ///
  /// In en, this message translates to:
  /// **'19'**
  String get ageValue;

  /// No description provided for @ageChip.
  ///
  /// In en, this message translates to:
  /// **'Age: {age}'**
  String ageChip(Object age);

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get summary;

  /// No description provided for @publicSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Live snapshot: {date}'**
  String publicSnapshot(Object date);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get aboutTitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get aboutSubtitle;

  /// No description provided for @aboutParagraph1.
  ///
  /// In en, this message translates to:
  /// **' TBD'**
  String get aboutParagraph1;

  /// No description provided for @aboutParagraph2.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get aboutParagraph2;

  /// No description provided for @aboutParagraph3.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get aboutParagraph3;

  /// No description provided for @codingProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Coding profiles'**
  String get codingProfilesTitle;

  /// No description provided for @codingProfilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Live public metrics from GitHub, Codeforces, and LeetCode. Each card links to the original profile.'**
  String get codingProfilesSubtitle;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @projectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Project cards focus on role, personal stack, repository stats, and commit counts fetched from GitHub APIs.'**
  String get projectsSubtitle;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsTitle;

  /// No description provided for @contactsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Direct links for messaging and source profiles.'**
  String get contactsSubtitle;

  /// No description provided for @footer.
  ///
  /// In en, this message translates to:
  /// **'Built with Flutter Web, l10n, live APIs, and feature-first architecture.'**
  String get footer;

  /// No description provided for @telegramNote.
  ///
  /// In en, this message translates to:
  /// **'Public handle'**
  String get telegramNote;

  /// No description provided for @emailValue.
  ///
  /// In en, this message translates to:
  /// **'add email'**
  String get emailValue;

  /// No description provided for @emailNote.
  ///
  /// In en, this message translates to:
  /// **'Not published in public profiles'**
  String get emailNote;

  /// No description provided for @githubContactValue.
  ///
  /// In en, this message translates to:
  /// **'github.com/Ars5njo'**
  String get githubContactValue;

  /// No description provided for @githubHeadline.
  ///
  /// In en, this message translates to:
  /// **'Arsen Latipov, public profile'**
  String get githubHeadline;

  /// No description provided for @codeforcesHeadline.
  ///
  /// In en, this message translates to:
  /// **'{rank}, {organization}'**
  String codeforcesHeadline(Object rank, Object organization);

  /// No description provided for @leetcodeHeadline.
  ///
  /// In en, this message translates to:
  /// **'{count} accepted problems'**
  String leetcodeHeadline(Object count);

  /// No description provided for @openPlatform.
  ///
  /// In en, this message translates to:
  /// **'Open {platform}'**
  String openPlatform(Object platform);

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'n/a'**
  String get notAvailable;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'not found'**
  String get notFound;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'manual'**
  String get manual;

  /// No description provided for @publicRepos.
  ///
  /// In en, this message translates to:
  /// **'Public repos'**
  String get publicRepos;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @maxRating.
  ///
  /// In en, this message translates to:
  /// **'Max rating'**
  String get maxRating;

  /// No description provided for @rank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get rank;

  /// No description provided for @contribution.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get contribution;

  /// No description provided for @solved.
  ///
  /// In en, this message translates to:
  /// **'Solved'**
  String get solved;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @githubRepos.
  ///
  /// In en, this message translates to:
  /// **'GitHub repos'**
  String get githubRepos;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'public'**
  String get public;

  /// No description provided for @codeforces.
  ///
  /// In en, this message translates to:
  /// **'Codeforces'**
  String get codeforces;

  /// No description provided for @leetcode.
  ///
  /// In en, this message translates to:
  /// **'LeetCode'**
  String get leetcode;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cfProfile.
  ///
  /// In en, this message translates to:
  /// **'CF profile'**
  String get cfProfile;

  /// No description provided for @repoCommits.
  ///
  /// In en, this message translates to:
  /// **'Repo commits'**
  String get repoCommits;

  /// No description provided for @myCommits.
  ///
  /// In en, this message translates to:
  /// **'My commits'**
  String get myCommits;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @topics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @publicRepo.
  ///
  /// In en, this message translates to:
  /// **'Public repo'**
  String get publicRepo;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @roleMetric.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleMetric;

  /// No description provided for @frontend.
  ///
  /// In en, this message translates to:
  /// **'frontend'**
  String get frontend;

  /// No description provided for @apiSource.
  ///
  /// In en, this message translates to:
  /// **'GitHub API'**
  String get apiSource;

  /// No description provided for @githubSearchSource.
  ///
  /// In en, this message translates to:
  /// **'GitHub Search API'**
  String get githubSearchSource;

  /// No description provided for @repoNotFoundNote.
  ///
  /// In en, this message translates to:
  /// **'GitHub Search API did not find a public load-balancer repository for this profile.'**
  String get repoNotFoundNote;

  /// No description provided for @tiktokDescription.
  ///
  /// In en, this message translates to:
  /// **'Offline reader for PDF/TXT books with RSVP mode, bionic text, local library and progress saving.'**
  String get tiktokDescription;

  /// No description provided for @tiktokRole.
  ///
  /// In en, this message translates to:
  /// **'Flutter feature work: reading flow, UI states, local data and project structure.'**
  String get tiktokRole;

  /// No description provided for @loadBalancerDescription.
  ///
  /// In en, this message translates to:
  /// **'Project about distributing incoming traffic between backend nodes: balancing algorithms, health checks, and service resilience.'**
  String get loadBalancerDescription;

  /// No description provided for @loadBalancerRole.
  ///
  /// In en, this message translates to:
  /// **'Public repository was not found; stack and contribution need manual confirmation.'**
  String get loadBalancerRole;

  /// No description provided for @vrataDescription.
  ///
  /// In en, this message translates to:
  /// **'Distributed room-based messenger with isolated Kafka topics, persistent history, and WebSocket/STOMP realtime delivery.'**
  String get vrataDescription;

  /// No description provided for @vrataRole.
  ///
  /// In en, this message translates to:
  /// **'Frontend role: Flutter Web client, feature-first layers, room/chat UI, and API integration.'**
  String get vrataRole;

  /// No description provided for @uiKitDescription.
  ///
  /// In en, this message translates to:
  /// **'Miracle Development UI kit: reusable Flutter widgets, themed components, story scenarios, and golden-testing workflow.'**
  String get uiKitDescription;

  /// No description provided for @uiKitRole.
  ///
  /// In en, this message translates to:
  /// **'Core contributor: components, stories, exports, theme support, and package maintenance.'**
  String get uiKitRole;

  /// No description provided for @tatarDescription.
  ///
  /// In en, this message translates to:
  /// **'Cold shower habit app with Flutter frontend, Go backend, PostgreSQL schema, and DevOps automation.'**
  String get tatarDescription;

  /// No description provided for @tatarRole.
  ///
  /// In en, this message translates to:
  /// **'Frontend Developer: auth flow, schedule editor, timer, dashboard states, and adaptive Flutter screens.'**
  String get tatarRole;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

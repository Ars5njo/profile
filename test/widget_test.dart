import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/app/profile_app.dart';
import 'package:profile/features/profile/data/profile_repository.dart';
import 'package:profile/features/profile/domain/entities/coding_profile.dart';
import 'package:profile/features/profile/domain/entities/contact_link.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/domain/entities/portfolio_project.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';
import 'package:profile/l10n/app_localizations.dart';

void main() {
  testWidgets('renders localized profile landing content', (tester) async {
    await tester.pumpWidget(ProfileApp(repository: _FakeProfileRepository()));
    await tester.pumpAndSettle();
    final scrollable = find.byType(Scrollable);

    expect(find.text('Арсен Латипов'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Обо мне'),
      500,
      scrollable: scrollable,
    );
    expect(find.text('Обо мне'), findsOneWidget);
    expect(find.text('Codeforces'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('tiktok-book'),
      500,
      scrollable: scrollable,
    );
    expect(find.text('tiktok-book'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('tatar-shower-app-flutter-go'),
      500,
      scrollable: scrollable,
    );
    expect(find.text('tatar-shower-app-flutter-go'), findsOneWidget);
  });
}

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<DeveloperProfile> loadProfile(AppLocalizations l10n) async {
    return DeveloperProfile(
      fullName: l10n.fullName,
      age: l10n.ageValue,
      role: l10n.role,
      location: l10n.location,
      avatarAssetPath: 'assets/images/arsen_latipov.jpeg',
      summary: l10n.summary,
      about: [l10n.aboutParagraph1],
      heroMetrics: [
        ProfileMetric(label: l10n.githubRepos, value: '6'),
        ProfileMetric(label: l10n.codeforces, value: '744'),
      ],
      contacts: const [
        ContactLink(
          label: 'Telegram',
          value: '@Ars5njo',
          icon: 'telegram',
          url: 'https://t.me/Ars5njo',
        ),
      ],
      codingProfiles: [
        CodingProfile(
          platform: 'Codeforces',
          handle: 'Ars5nj0',
          url: 'https://codeforces.com/profile/Ars5nj0',
          headline: 'newbie',
          accent: ProfileAccent.coral,
          metrics: [ProfileMetric(label: l10n.rating, value: '744')],
        ),
      ],
      projects: [
        PortfolioProject(
          name: 'tiktok-book',
          logoText: 'TB',
          description: l10n.tiktokDescription,
          role: l10n.tiktokRole,
          stack: const ['Flutter'],
          metrics: [ProfileMetric(label: l10n.repoCommits, value: '111')],
          accent: ProfileAccent.teal,
        ),
        PortfolioProject(
          name: 'tatar-shower-app-flutter-go',
          logoText: 'TS',
          description: l10n.tatarDescription,
          role: l10n.tatarRole,
          stack: const ['Flutter'],
          metrics: [ProfileMetric(label: l10n.repoCommits, value: '73')],
          accent: ProfileAccent.amber,
        ),
      ],
      updatedAtLabel: l10n.publicSnapshot('May 11, 2026'),
    );
  }
}

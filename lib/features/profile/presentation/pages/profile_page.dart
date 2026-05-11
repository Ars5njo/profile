import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/data/profile_repository.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/presentation/widgets/about_section.dart';
import 'package:profile/features/profile/presentation/widgets/coding_profiles_section.dart';
import 'package:profile/features/profile/presentation/widgets/contact_section.dart';
import 'package:profile/features/profile/presentation/widgets/profile_hero.dart';
import 'package:profile/features/profile/presentation/widgets/projects_section.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';
import 'package:profile/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.repository,
    required this.currentLocale,
    required this.onLocaleChanged,
    super.key,
  });

  final ProfileRepository repository;
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<DeveloperProfile>? _profileFuture;
  Locale? _loadedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureProfileFuture();
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository != widget.repository ||
        oldWidget.currentLocale != widget.currentLocale) {
      _profileFuture = null;
      _ensureProfileFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SelectionArea(
        child: Column(
          children: [
            _TopBar(
              currentLocale: widget.currentLocale,
              onLocaleChanged: widget.onLocaleChanged,
            ),
            Expanded(
              child: FutureBuilder<DeveloperProfile>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return _LoadingView(l10n: l10n);
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return _ErrorView(
                      l10n: l10n,
                      onRetry: () {
                        setState(() {
                          _profileFuture = widget.repository.loadProfile(l10n);
                        });
                      },
                    );
                  }

                  return _ProfileContent(profile: snapshot.data!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _ensureProfileFuture() {
    final locale = Localizations.localeOf(context);
    if (_profileFuture != null && _loadedLocale == locale) return;

    _loadedLocale = locale;
    _profileFuture = widget.repository.loadProfile(
      AppLocalizations.of(context),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.currentLocale, required this.onLocaleChanged});

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.canvas.withValues(alpha: 0.94),
        border: Border(
          bottom: BorderSide(color: AppTheme.line.withValues(alpha: 0.75)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SectionShell(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'AL',
                  style: TextStyle(
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  l10n.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _LanguageSwitch(
                currentLocale: currentLocale,
                onLocaleChanged: onLocaleChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.surfaceHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppTheme.primaryStrong.withValues(alpha: 0.24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageOption(
            label: l10n.languageRu,
            isSelected: currentLocale.languageCode == 'ru',
            onTap: () => onLocaleChanged(const Locale('ru')),
          ),
          _LanguageOption(
            label: l10n.languageEn,
            isSelected: currentLocale.languageCode == 'en',
            onTap: () => onLocaleChanged(const Locale('en')),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryStrong : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF003543) : AppTheme.mutedInk,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final DeveloperProfile profile;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: ProfileHero(profile: profile)),

        SliverToBoxAdapter(child: AboutSection(profile: profile)),

        SliverToBoxAdapter(
          child: CodingProfilesSection(profiles: profile.codingProfiles),
        ),

        SliverToBoxAdapter(child: ProjectsSection(projects: profile.projects)),

        SliverToBoxAdapter(child: ContactSection(contacts: profile.contacts)),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppTheme.primaryStrong),
                const SizedBox(height: 20),
                Text(
                  l10n.loadingProfile,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loadingHint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.mutedInk, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.l10n, required this.onRetry});

  final AppLocalizations l10n;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_off_rounded,
                  color: AppTheme.coral,
                  size: 42,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.loadErrorTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loadErrorBody,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.mutedInk, height: 1.5),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

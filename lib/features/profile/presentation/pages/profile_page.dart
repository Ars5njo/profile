import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/data/profile_repository.dart';
import 'package:profile/features/profile/presentation/widgets/about_section.dart';
import 'package:profile/features/profile/presentation/widgets/coding_profiles_section.dart';
import 'package:profile/features/profile/presentation/widgets/contact_section.dart';
import 'package:profile/features/profile/presentation/widgets/profile_hero.dart';
import 'package:profile/features/profile/presentation/widgets/projects_section.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({this.repository = const ProfileRepository(), super.key});

  final ProfileRepository repository;

  @override
  Widget build(BuildContext context) {
    final profile = repository.loadProfile();

    return Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHero(profile: profile),
              AboutSection(profile: profile),
              CodingProfilesSection(profiles: profile.codingProfiles),
              ProjectsSection(projects: profile.projects),
              ContactSection(contacts: profile.contacts),
              const _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Built with Flutter Web and feature-first architecture.',
              style: TextStyle(
                color: AppTheme.mutedInk,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            DateTime.now().year.toString(),
            style: const TextStyle(
              color: AppTheme.mutedInk,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

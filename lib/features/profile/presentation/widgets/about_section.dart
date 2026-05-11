import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';
import 'package:profile/l10n/app_localizations.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.profile, super.key});

  final DeveloperProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SectionShell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;

          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isWide ? 320 : double.infinity,
                child: SectionHeader(
                  title: l10n.aboutTitle,
                  subtitle: l10n.aboutSubtitle,
                ),
              ),
              SizedBox(width: isWide ? 56 : 0, height: isWide ? 0 : 28),
              if (isWide)
                Expanded(child: _AboutCopy(profile: profile))
              else
                _AboutCopy(profile: profile),
            ],
          );
        },
      ),
    );
  }
}

class _AboutCopy extends StatelessWidget {
  const _AboutCopy({required this.profile});

  final DeveloperProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final paragraph in profile.about) ...[
          Text(
            paragraph,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.mutedInk,
                  height: 1.62,
                ),
          ),
          if (paragraph != profile.about.last) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

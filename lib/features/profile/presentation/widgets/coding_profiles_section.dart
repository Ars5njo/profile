import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/coding_profile.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';
import 'package:profile/features/profile/presentation/widgets/external_link_button.dart';
import 'package:profile/features/profile/presentation/widgets/profile_colors.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';
import 'package:profile/l10n/app_localizations.dart';

class CodingProfilesSection extends StatelessWidget {
  const CodingProfilesSection({required this.profiles, super.key});

  final List<CodingProfile> profiles;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: l10n.codingProfilesTitle,
            subtitle: l10n.codingProfilesSubtitle,
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth >= 980
                  ? (constraints.maxWidth - 32) / 3
                  : constraints.maxWidth >= 660
                  ? (constraints.maxWidth - 16) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final profile in profiles)
                    SizedBox(
                      width: cardWidth,
                      child: _CodingProfileCard(profile: profile),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CodingProfileCard extends StatelessWidget {
  const _CodingProfileCard({required this.profile});

  final CodingProfile profile;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor(profile.accent);

    final l10n = AppLocalizations.of(context);

    return GlassPanel(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentFill(profile.accent),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: accent.withValues(alpha: 0.22)),
                ),
                child: Text(
                  profile.platform.characters.take(2).join().toUpperCase(),
                  style: TextStyle(color: accent, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.platform,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      profile.handle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.mutedInk,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _MetricsGrid(metrics: profile.metrics),
          const SizedBox(height: 18),
          ExternalLinkButton(
            label: l10n.openPlatform(profile.platform),
            url: profile.url,
            icon: Icons.open_in_new_rounded,
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final metric in metrics)
          SizedBox(
            width: 120,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppTheme.canvas.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 23,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          metric.value,
                          maxLines: 1,
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      metric.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.mutedInk,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/portfolio_project.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';
import 'package:profile/features/profile/presentation/widgets/external_link_button.dart';
import 'package:profile/features/profile/presentation/widgets/profile_colors.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';
import 'package:profile/l10n/app_localizations.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({required this.projects, super.key});

  final List<PortfolioProject> projects;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: l10n.projectsTitle,
            subtitle: l10n.projectsSubtitle,
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth >= 820
                  ? (constraints.maxWidth - 18) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  for (final project in projects)
                    SizedBox(
                      width: width,
                      child: ProjectCard(project: project),
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

class ProjectCard extends StatelessWidget {
  const ProjectCard({required this.project, super.key});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor(project.accent);

    final l10n = AppLocalizations.of(context);

    return GlassPanel(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectLogo(project: project),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.role,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in project.stack)
                Chip(label: Text(item), visualDensity: VisualDensity.compact),
            ],
          ),
          const SizedBox(height: 18),
          _ProjectMetrics(metrics: project.metrics),
          if (project.hasPublicUrl) ...[
            const SizedBox(height: 18),
            ExternalLinkButton(
              label: l10n.repository,
              url: project.url!,
              icon: Icons.code_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

class ProjectLogo extends StatelessWidget {
  const ProjectLogo({required this.project, super.key});

  final PortfolioProject project;

  @override
  Widget build(BuildContext context) {
    final accent = accentColor(project.accent);

    return Container(
      width: 58,
      height: 58,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accentFill(project.accent),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
      ),
      child: Text(
        project.logoText,
        style: TextStyle(
          color: accent,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _ProjectMetrics extends StatelessWidget {
  const _ProjectMetrics({required this.metrics});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final metric in metrics)
          Container(
            constraints: const BoxConstraints(minWidth: 112, maxWidth: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.canvas.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 21,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      metric.value,
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
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
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

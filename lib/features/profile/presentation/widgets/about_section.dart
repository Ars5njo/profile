import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.profile, super.key});

  final DeveloperProfile profile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      backgroundColor: Colors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;

          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isWide ? 320 : double.infinity,
                child: const SectionHeader(
                  title: 'Обо мне',
                  subtitle:
                      'Короткий профиль без лишней витрины: чем занимаюсь, '
                      'какие задачи беру и как обычно встраиваюсь в проект.',
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
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.ink, height: 1.62),
          ),
          if (paragraph != profile.about.last) const SizedBox(height: 18),
        ],
      ],
    );
  }
}

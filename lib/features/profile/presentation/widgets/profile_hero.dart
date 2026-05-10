import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/developer_profile.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';
import 'package:profile/features/profile/presentation/widgets/external_link_button.dart';
import 'package:profile/features/profile/presentation/widgets/profile_colors.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';

class ProfileHero extends StatelessWidget {
  const ProfileHero({required this.profile, super.key});

  final DeveloperProfile profile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 56),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroTopLine(updatedAtLabel: profile.updatedAtLabel),
              SizedBox(height: isWide ? 52 : 34),
              Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: isWide
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  _ProfilePhoto(
                    avatarAssetPath: profile.avatarAssetPath,
                    fullName: profile.fullName,
                    size: isWide ? 256 : 164,
                  ),
                  SizedBox(width: isWide ? 56 : 0, height: isWide ? 0 : 28),
                  if (isWide)
                    Expanded(child: _HeroCopy(profile: profile))
                  else
                    _HeroCopy(profile: profile),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroTopLine extends StatelessWidget {
  const _HeroTopLine({required this.updatedAtLabel});

  final String updatedAtLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.ink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'AL',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Arsen Latipov',
          style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.ink),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            updatedAtLabel,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppTheme.mutedInk,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.profile});

  final DeveloperProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryContacts = profile.contacts
        .where((contact) => contact.isAvailable)
        .take(2)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _InfoChip(label: profile.role, icon: Icons.work_outline_rounded),
            _InfoChip(label: profile.location, icon: Icons.place_outlined),
            _InfoChip(
              label: 'Возраст: ${profile.age}',
              icon: Icons.cake_outlined,
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          profile.fullName,
          style: textTheme.displaySmall?.copyWith(
            color: AppTheme.ink,
            fontWeight: FontWeight.w900,
            height: 1.04,
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            profile.summary,
            style: textTheme.titleMedium?.copyWith(
              color: AppTheme.mutedInk,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 26),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final contact in primaryContacts)
              ExternalLinkButton(
                label: contact.label,
                url: contact.url!,
                icon: contactIcon(contact.icon),
                isPrimary: contact == primaryContacts.first,
              ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final metric in profile.heroMetrics)
              _HeroMetric(metric: metric),
          ],
        ),
      ],
    );
  }
}

class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto({
    required this.avatarAssetPath,
    required this.fullName,
    required this.size,
  });

  final String avatarAssetPath;
  final String fullName;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.line),
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 18),
            color: AppTheme.ink.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          avatarAssetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: AppTheme.ink,
              child: Center(
                child: Text(
                  _initials(fullName),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size / 4,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    return name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part.characters.first)
        .join();
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.teal),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.metric});

  final ProfileMetric metric;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    metric.value,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 18,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    metric.label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              if (metric.caption case final caption?) ...[
                const SizedBox(height: 2),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppTheme.mutedInk,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

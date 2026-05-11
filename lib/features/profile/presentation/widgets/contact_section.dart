import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/contact_link.dart';
import 'package:profile/features/profile/presentation/widgets/external_link_button.dart';
import 'package:profile/features/profile/presentation/widgets/profile_colors.dart';
import 'package:profile/features/profile/presentation/widgets/section_shell.dart';
import 'package:profile/l10n/app_localizations.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({required this.contacts, super.key});

  final List<ContactLink> contacts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: l10n.contactsTitle,
            subtitle: l10n.contactsSubtitle,
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth >= 760
                  ? (constraints.maxWidth - 24) / 3
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final contact in contacts)
                    SizedBox(
                      width: width,
                      child: _ContactCard(contact: contact),
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

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact});

  final ContactLink contact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GlassPanel(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(contactIcon(contact.icon), color: AppTheme.primary),
          const SizedBox(height: 14),
          Text(
            contact.label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            contact.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.mutedInk,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (contact.note case final note?) ...[
            const SizedBox(height: 8),
            Text(
              note,
              style: const TextStyle(
                color: AppTheme.faintInk,
                fontSize: 12,
                height: 1.35,
              ),
            ),
          ],
          if (contact.isAvailable) ...[
            const SizedBox(height: 16),
            ExternalLinkButton(
              label: l10n.openPlatform(contact.label),
              url: contact.url!,
              icon: Icons.open_in_new_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

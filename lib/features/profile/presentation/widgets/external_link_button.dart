import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLinkButton extends StatelessWidget {
  const ExternalLinkButton({
    required this.label,
    required this.url,
    this.icon = Icons.open_in_new_rounded,
    this.isPrimary = false,
    super.key,
  });

  final String label;
  final String url;
  final IconData icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    void onPressed() => _openUrl(context, url);

    if (isPrimary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final uri = Uri.parse(url);
    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch && messenger != null) {
      messenger.showSnackBar(SnackBar(content: Text('Could not open $url')));
    }
  }
}

import 'package:profile/features/profile/domain/entities/coding_profile.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';

class PortfolioProject {
  const PortfolioProject({
    required this.name,
    required this.logoText,
    required this.description,
    required this.role,
    required this.stack,
    required this.metrics,
    required this.accent,
    this.url,
    this.sourceNote,
  });

  final String name;
  final String logoText;
  final String description;
  final String role;
  final List<String> stack;
  final List<ProfileMetric> metrics;
  final ProfileAccent accent;
  final String? url;
  final String? sourceNote;

  bool get hasPublicUrl => url != null && url!.isNotEmpty;
}

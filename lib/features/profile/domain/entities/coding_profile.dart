import 'package:profile/features/profile/domain/entities/profile_metric.dart';

class CodingProfile {
  const CodingProfile({
    required this.platform,
    required this.handle,
    required this.url,
    required this.headline,
    required this.metrics,
    required this.accent,
  });

  final String platform;
  final String handle;
  final String url;
  final String headline;
  final List<ProfileMetric> metrics;
  final ProfileAccent accent;
}

enum ProfileAccent { teal, amber, coral, violet, blue }

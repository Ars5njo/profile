import 'package:profile/features/profile/domain/entities/coding_profile.dart';
import 'package:profile/features/profile/domain/entities/contact_link.dart';
import 'package:profile/features/profile/domain/entities/portfolio_project.dart';
import 'package:profile/features/profile/domain/entities/profile_metric.dart';

class DeveloperProfile {
  const DeveloperProfile({
    required this.fullName,
    required this.age,
    required this.role,
    required this.location,
    required this.avatarAssetPath,
    required this.summary,
    required this.about,
    required this.heroMetrics,
    required this.contacts,
    required this.codingProfiles,
    required this.projects,
    required this.updatedAtLabel,
  });

  final String fullName;
  final String age;
  final String role;
  final String location;
  final String avatarAssetPath;
  final String summary;
  final List<String> about;
  final List<ProfileMetric> heroMetrics;
  final List<ContactLink> contacts;
  final List<CodingProfile> codingProfiles;
  final List<PortfolioProject> projects;
  final String updatedAtLabel;
}

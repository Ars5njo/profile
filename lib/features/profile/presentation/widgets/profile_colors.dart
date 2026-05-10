import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/domain/entities/coding_profile.dart';

Color accentColor(ProfileAccent accent) {
  return switch (accent) {
    ProfileAccent.teal => AppTheme.teal,
    ProfileAccent.amber => AppTheme.amber,
    ProfileAccent.coral => AppTheme.coral,
    ProfileAccent.violet => AppTheme.violet,
    ProfileAccent.blue => AppTheme.blue,
  };
}

Color accentFill(ProfileAccent accent) {
  return Color.alphaBlend(
    accentColor(accent).withValues(alpha: 0.12),
    AppTheme.surface,
  );
}

IconData contactIcon(String icon) {
  return switch (icon) {
    'telegram' => Icons.send_rounded,
    'mail' => Icons.alternate_email_rounded,
    'github' => Icons.code_rounded,
    _ => Icons.link_rounded,
  };
}

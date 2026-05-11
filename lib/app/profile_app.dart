import 'package:flutter/material.dart';
import 'package:profile/core/theme/app_theme.dart';
import 'package:profile/features/profile/data/profile_repository.dart';
import 'package:profile/features/profile/presentation/pages/profile_page.dart';
import 'package:profile/l10n/app_localizations.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({this.repository, super.key});

  final ProfileRepository? repository;

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  Locale _locale = const Locale('ru');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.dark(),
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          return ProfilePage(
            repository: widget.repository ?? NetworkProfileRepository(),
            currentLocale: _locale,
            onLocaleChanged: (locale) => setState(() => _locale = locale),
          );
        },
      ),
    );
  }
}

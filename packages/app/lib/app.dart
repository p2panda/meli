// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/router.dart';

class MeliApp extends StatelessWidget {
  MeliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Register router for navigation
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,

      // Setup localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      // Material theme configuration
      theme: ThemeData(useMaterial3: true),

      // Disable "debug" banner shown in top right corner during development
      debugShowCheckedModeBanner: false,
    );
  }
}

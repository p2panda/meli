// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/router.dart';
import 'package:app/ui/widgets/image_provider.dart';
import 'package:app/io/graphql/graphql.dart' as graphql;

class MeliApp extends StatefulWidget {
  MeliApp({super.key});

  @override
  State<MeliApp> createState() => MeliAppState();
}

class MeliAppState extends State<MeliApp> {
  Locale? _locale;

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> client = ValueNotifier(graphql.client);

    return GraphQLProvider(
        client: client,
        child: MeliCameraProvider(MaterialApp.router(
          // Register router for navigation
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,

          // Setup localization
          locale: _locale,
          localeResolutionCallback: (locale, supportedLocales) {
            if (supportedLocales.contains(locale)) {
              return locale;
            }

            if (locale?.languageCode == 'en') {
              return Locale('en');
            }
            return Locale('pt');
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // Material theme configuration
          theme: ThemeData(useMaterial3: true),

          // Disable "debug" banner shown in top right corner during development
          debugShowCheckedModeBanner: false,
        )));
  }
}

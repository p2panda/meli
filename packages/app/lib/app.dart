// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/io/graphql/graphql.dart' as graphql;
import 'package:app/router.dart';
import 'package:app/ui/widgets/image_provider.dart';
import 'package:app/ui/widgets/refresh_provider.dart';

class MeliApp extends StatefulWidget {
  const MeliApp({super.key});

  @override
  State<MeliApp> createState() => MeliAppState();
}

class MeliAppState extends State<MeliApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      final String localString = prefs.getString('locale') ?? 'pt';
      setState(() {
        _locale = Locale(localString);
      });
    });
  }

  Future<bool> changeLocale(Locale locale) async {
    final SharedPreferences prefs = await _prefs;
    bool success = await prefs.setString('locale', locale.toString());

    if (success) {
      setState(() {
        _locale = locale;
      });
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<GraphQLClient> client = ValueNotifier(graphql.client);

    return GraphQLProvider(
        client: client,
        child: RefreshProvider(
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

            return const Locale('pt');
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // Material theme configuration
          theme: ThemeData(useMaterial3: true),

          // Disable "debug" banner shown in top right corner during development
          debugShowCheckedModeBanner: false,
        ))));
  }
}

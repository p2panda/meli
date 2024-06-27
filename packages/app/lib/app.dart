// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/io/graphql/graphql.dart' as graphql;
import 'package:app/router.dart';
import 'package:app/ui/widgets/connected_peers_provider.dart';
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

    // Set locale to user setting if given
    _prefs.then((SharedPreferences prefs) {
      final String? localString = prefs.getString('locale');
      if (localString != null) {
        setState(() {
          _locale = Locale(localString);
        });
      }
    });
  }

  Future<bool> changeLocale(String languageCode) async {
    final SharedPreferences prefs = await _prefs;
    bool success = await prefs.setString('locale', languageCode.toString());

    if (success) {
      setState(() {
        _locale = Locale(languageCode);
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
            child: MeliCameraProvider(ConnectedPeersProvider(
                child: MaterialApp.router(
          // Register router for navigation
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,

          // Setup localization
          locale: _locale,
          localeListResolutionCallback: (locales, supportedLocales) {
            // Check if we can fullfil the preferred locale of the device OS
            // ordered by priority
            if (locales != null) {
              final supportedLanguageCodes =
                  supportedLocales.map((supportedLocale) {
                return supportedLocale.languageCode;
              });

              for (var locale in locales) {
                if (supportedLanguageCodes.contains(locale.languageCode)) {
                  return locale;
                }
              }
            }

            return const Locale('pt');
          },
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // Material theme configuration
          theme: ThemeData(useMaterial3: true),

          // Disable "debug" banner shown in top right corner during development
          debugShowCheckedModeBanner: false,
        )))));
  }
}

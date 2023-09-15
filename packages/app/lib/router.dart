// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/ui/screens/all_sightings.dart';
import 'package:app/ui/screens/all_species.dart';
import 'package:app/ui/screens/create_new.dart';
import 'package:app/ui/screens/create_species.dart';
import 'package:app/ui/screens/settings.dart';

class RoutePath {
  static String splash = '/';
  static String allSightings = '/sightings';
  static String settings = '/settings';
  static String createNew = '/createNew';
  static String createSpecies = '/createSpecies';
  static String allSpecies = '/species';
}

final router = GoRouter(routes: [
  // The splash route is just a dummy which gets loaded in the background while
  // the native splash screen is shown. We have this in place to not have any
  // app logic running yet while everything else is bootstrapping.
  _Route(RoutePath.splash, (_) => Container(color: Colors.white)),
  _Route(RoutePath.allSightings, (_) => AllSightingsScreen()),
  _Route(RoutePath.settings, (_) => SettingsScreen()),
  _Route(RoutePath.createNew, (_) => CreateNewScreen()),
  _Route(RoutePath.createSpecies, (_) => CreateSpeciesScreen()),
  _Route(RoutePath.allSpecies, (_) => AllSpeciesScreen()),
]);

class _Route extends GoRoute {
  _Route(String path, Widget Function(GoRouterState state) builder)
      : super(
            path: path,
            routes: const [],
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: builder(state),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final tween =
                        Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.ease));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  });
            });
}

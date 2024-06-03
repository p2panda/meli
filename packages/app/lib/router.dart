// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/ui/screens/all_sightings.dart';
import 'package:app/ui/screens/all_species.dart';
import 'package:app/ui/screens/create_sighting.dart';
import 'package:app/ui/screens/settings.dart';
import 'package:app/ui/screens/sighting.dart';
import 'package:app/ui/screens/species.dart';
import 'package:app/ui/screens/splash.dart';

class RoutePath {
  final String name;
  final String path;

  RoutePath(this.name, this.path);
}

class RoutePaths {
  static RoutePath splash = RoutePath('splash', '/');
  static RoutePath settings = RoutePath('settings', '/settings');
  static RoutePath allSightings = RoutePath('all_sightings', '/sightings');
  static RoutePath allSpecies = RoutePath('all_species', '/species');
  static RoutePath sighting = RoutePath('sighting', '/sighting/:documentId');
  static RoutePath species = RoutePath('species', '/species/:documentId');
  static RoutePath createSighting =
      RoutePath('create_sighting', '/create/sighting');
}

final router = GoRouter(routes: [
  _Route(RoutePaths.splash, (_) => const SplashScreen()),
  _Route(RoutePaths.settings, (_) => const SettingsScreen()),
  _Route(RoutePaths.allSightings, (_) => AllSightingsScreen()),
  _Route(RoutePaths.allSpecies, (_) => AllSpeciesScreen()),
  _Route(
      RoutePaths.sighting,
      (state) =>
          SightingScreen(documentId: state.pathParameters["documentId"]!)),
  _Route(
      RoutePaths.species,
      (state) =>
          SpeciesScreen(documentId: state.pathParameters["documentId"]!)),
  _Route(RoutePaths.createSighting, (_) => const CreateSightingScreen()),
]);

class _Route extends GoRoute {
  _Route(RoutePath route, Widget Function(GoRouterState state) builder)
      : super(
            name: route.name,
            path: route.path,
            routes: const [],
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                  key: state.pageKey,
                  child: builder(state),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    final tween =
                        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.ease));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  });
            });
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/screens/create_new.dart';
import 'package:app/ui/screens/image_from_gallery.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/ui/screens/all_sightings.dart';
import 'package:app/ui/screens/all_species.dart';
import 'package:app/ui/screens/sighting.dart';
import 'package:app/ui/screens/settings.dart';

class RoutePath {
  final String name;
  final String path;

  RoutePath(this.name, this.path);
}

class RoutePaths {
  static RoutePath splash = RoutePath('splash', '/');
  static RoutePath allSightings = RoutePath('all_sightings', '/allSightings');
  static RoutePath sighting = RoutePath('sightings', '/sighting');
  static RoutePath settings = RoutePath('settings', '/settings');
  static RoutePath createSighting =
      RoutePath('create_sighting', '/createSighting');
  static RoutePath allSpecies = RoutePath('species', '/species');
  static RoutePath imagePicker = RoutePath('image_picker', '/imagePicker');
}

final router = GoRouter(routes: [
  // The splash route is just a dummy which gets loaded in the background while
  // the native splash screen is shown. We have this in place to not have any
  // app logic running yet while everything else is bootstrapping.
  _Route(RoutePaths.splash, (_) => Container(color: Colors.white)),
  _Route(RoutePaths.allSightings, (_) => AllSightingsScreen()),
  _Route(RoutePaths.sighting,
      (state) => SightingScreen(id: state.queryParameters["id"]!)),
  _Route(RoutePaths.settings, (_) => SettingsScreen()),
  _Route(RoutePaths.createSighting, (_) => CreateNewScreen()),
  _Route(RoutePaths.imagePicker,
      (state) => ImageFromGalleryEx(state.queryParameters["type"]!)),
  _Route(RoutePaths.allSpecies, (_) => AllSpeciesScreen()),
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
                        Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.ease));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  });
            });
}

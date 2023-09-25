// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/screens/create_new.dart';
import 'package:app/ui/screens/image_from_gallery.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/ui/screens/all_sightings.dart';
import 'package:app/ui/screens/all_species.dart';
import 'package:app/ui/screens/sighting.dart';
import 'package:app/ui/screens/settings.dart';

class Route {
  final String name;
  final String path;

  Route(this.name, this.path);
}

class Routes {
  static Route splash = Route('splash', '/');
  static Route allSightings = Route('all_sightings', '/allSightings');
  static Route sighting = Route('sightings', '/sighting');
  static Route settings = Route('settings', '/settings');
  static Route createSighting = Route('create_sighting', '/createSighting');
  static Route allSpecies = Route('species', '/species');
  static Route imagePicker = Route('image_picker', '/imagePicker');
}

final router = GoRouter(routes: [
  // The splash route is just a dummy which gets loaded in the background while
  // the native splash screen is shown. We have this in place to not have any
  // app logic running yet while everything else is bootstrapping.
  _Route(Routes.splash, (_) => Container(color: Colors.white)),
  _Route(Routes.allSightings, (_) => AllSightingsScreen()),
  _Route(
      Routes.sighting, (state) => SightingScreen(id: state.extra.toString())),
  _Route(Routes.settings, (_) => SettingsScreen()),
  _Route(Routes.createSighting, (_) => CreateNewScreen()),
  _Route(Routes.imagePicker, (_) => ImageFromGalleryEx("")),
  _Route(Routes.allSpecies, (_) => AllSpeciesScreen()),
]);

class _Route extends GoRoute {
  _Route(Route route, Widget Function(GoRouterState state) builder)
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

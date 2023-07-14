import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/screens/home.dart';
import 'package:app/screens/create_new.dart';
import 'package:app/screens/all_species.dart';
import 'package:app/screens/settings.dart';

class RoutePath {
  static String home = '/'; // sightings
  static String settings = '/settings';
  static String createNew = '/createNew';
  static String allSpecies = '/species';
}

final router = GoRouter(routes: [
  _Route(RoutePath.home, (_) => HomeScreen()),
  _Route(RoutePath.settings, (_) => SettingsScreen()),
  _Route(RoutePath.createNew, (_) => CreateNewScreen()),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/screens/home.dart';

class RoutePath {
  static String home = '/';
}

final router = GoRouter(
  routes: [
    Route(RoutePath.home, (_) => HomeScreen()),
  ]
);

class Route extends GoRoute {
  Route(String path, Widget Function(GoRouterState state) builder):
    super(
      path: path,
      routes: const [],
      pageBuilder: (context, state) {
        return CustomTransitionPage(
            key: state.pageKey,
            child: builder(state),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.ease));

              return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
              );
            }
        );
      }
    );
}
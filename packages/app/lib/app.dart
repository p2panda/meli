import 'package:flutter/material.dart';

import 'package:app/router.dart';

class MeliApp extends StatelessWidget {
  MeliApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Register router for navigation
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,

      // Disable "debug" banner shown in top right corner during development
      debugShowCheckedModeBanner: false,
    );
  }
}
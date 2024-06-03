// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MeliColors.magnolia,
        padding: const EdgeInsets.all(30.0),
        child: const Center(
          child: CircularProgressIndicator(
            color: MeliColors.black,
          ),
        ));
  }
}

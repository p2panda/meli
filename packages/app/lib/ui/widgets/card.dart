// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

const borderSide = BorderSide(
  width: 6.0,
  strokeAlign: BorderSide.strokeAlignCenter,
  color: MeliColors.pink,
);
const borderRadius = BorderRadius.all(Radius.circular(12.0));

class MeliCard extends StatelessWidget {
  final Widget child;

  MeliCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        color: MeliColors.pink,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: borderSide,
          borderRadius: borderRadius,
        ),
        child: this.child);
  }
}

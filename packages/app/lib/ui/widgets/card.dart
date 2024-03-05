// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class MeliCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color color;
  final double borderWidth;
  final Color borderColor;

  const MeliCard(
      {super.key,
      required this.child,
      this.elevation = 5.0,
      this.borderWidth = 6.0,
      this.borderColor = MeliColors.pink,
      this.color = MeliColors.pink});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: elevation,
        color: color,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: borderWidth,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: borderColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        child: child);
  }
}

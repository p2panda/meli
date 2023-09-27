// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class MeliCard extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color color;

  MeliCard(
      {super.key,
      required this.child,
      this.elevation = 5.0,
      this.color = MeliColors.pink});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: this.elevation,
        color: this.color,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 6.0,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: this.color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: this.child);
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/colors.dart';

class MeliCard extends StatelessWidget {
  final Widget child;

  MeliCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: MeliColors.magnolia,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 5,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: MeliColors.magnolia,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(1),
        child: this.child,
      ),
    );
  }
}

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
      child: Column(
        children: [
          Container(
            width: 360,
            height: 233,
            padding: const EdgeInsets.all(1),
            decoration: ShapeDecoration(
              color: MeliColors.magnolia,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: MeliColors.magnolia,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: this.child,
          ),
        ],
      ),
    );
  }
}

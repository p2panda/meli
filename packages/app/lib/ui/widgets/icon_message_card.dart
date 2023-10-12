// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';

class IconMessageCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;

  IconMessageCard(
      {super.key,
      required this.message,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return MeliCard(
        elevation: 3.0,
        color: this.color,
        borderWidth: 0.0,
        child: SizedBox(
          width: double.infinity,
          child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(children: [
                Icon(
                  this.icon,
                  size: 40.0,
                  color: MeliColors.black,
                ),
                const SizedBox(height: 10.0),
                Text(this.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
              ])),
        ));
  }
}

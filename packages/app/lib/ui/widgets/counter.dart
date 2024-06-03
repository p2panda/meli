// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class Counter extends StatelessWidget {
  final int value;

  const Counter(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.0,
      height: 22.0,
      decoration: BoxDecoration(
        color: MeliColors.plum,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: MeliColors.plum,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: const TextStyle(
            color: MeliColors.white,
            fontSize: 13.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

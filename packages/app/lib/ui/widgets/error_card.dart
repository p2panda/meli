// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class ErrorCard extends StatelessWidget {
  final String message;

  ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        color: MeliColors.peach,
        child: SizedBox(
          width: double.infinity,
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(children: [
                Icon(
                  Icons.warning_rounded,
                  size: 40.0,
                  color: MeliColors.black,
                ),
                SizedBox(height: 10.0),
                Text(this.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge),
              ])),
        ));
  }
}

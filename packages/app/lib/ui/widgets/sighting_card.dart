// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'card.dart';

class SightingCard extends StatelessWidget {
  final String species;
  final String img;
  final String dateTime;

  SightingCard(
      {super.key,
      required this.species,
      required this.img,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      title: this.species,
      subtitle: this.dateTime,
      child: Container(
        height: 240,
        width: double.infinity,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(this.img),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

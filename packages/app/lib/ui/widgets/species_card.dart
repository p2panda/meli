// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'card.dart';

class SpeciesCard extends StatelessWidget {
  SpeciesCard({
    super.key,
    required this.name,
    required this.img,
  });

  final String name;
  final String img;

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      footer: this.name,
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

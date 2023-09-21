// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'card.dart';

class SightingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? image;

  SightingCard({super.key, this.image, this.subtitle, required this.title});

  List<Widget> _image() {
    if (this.image != null) {
      return [
        Container(
          height: 240,
          width: double.infinity,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: NetworkImage(this.image!),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        )
      ];
    }
    else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      title: this.title,
      subtitle: this.subtitle,
      children: this._image(),
    );
  }
}

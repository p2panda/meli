// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'card.dart';

class ImageCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String img;
  final String? footer;

  ImageCard(
      {super.key, required this.img, this.title, this.subtitle, this.footer});

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      title: this.title,
      subtitle: this.subtitle,
      footer: this.footer,
      children: [
        Container(
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
        )
      ],
    );
  }
}

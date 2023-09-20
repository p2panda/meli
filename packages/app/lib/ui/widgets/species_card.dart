// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class SpeciesCard extends StatelessWidget {
  final String title;
  final String image;

  SpeciesCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: MeliColors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 3,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: MeliColors.white,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Container(
              margin: const EdgeInsets.all(5),
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(this.image),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
          Container(
            padding: const EdgeInsets.only(
                top: 8.0, right: 6.0, bottom: 10.0, left: 6.0),
            alignment: AlignmentDirectional.center,
            child: Text(
              this.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ]));
  }
}

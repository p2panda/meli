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
      child: Container(
        height: 260,
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        this.species,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        this.dateTime,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

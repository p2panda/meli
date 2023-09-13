// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class SpeciesCard extends StatefulWidget {
  final String name;
  final String img;

  SpeciesCard({super.key, required this.name, required this.img});

  @override
  State<SpeciesCard> createState() => _SpeciesCardState();
}

class _SpeciesCardState extends State<SpeciesCard> {
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
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 3,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(this.widget.img),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  padding: const EdgeInsets.only(
                      top: 8, left: 6, right: 6, bottom: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 330,
                        child: Text(
                          this.widget.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

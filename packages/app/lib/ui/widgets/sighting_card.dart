// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';

class SightingCard extends StatefulWidget {
  final String? localName;
  final DateTime date;
  final String image;
  final String? speciesName;
  final VoidCallback onTap;

  SightingCard(
      {super.key,
      this.localName,
      required this.onTap,
      required this.date,
      required this.image,
      this.speciesName});

  @override
  State<SightingCard> createState() => _SightingCardState();
}

class _SightingCardState extends State<SightingCard> {
  bool isSelected = false;

  String get _title {
    if (this.widget.speciesName != null) {
      return this.widget.speciesName!;
    }

    if (this.widget.localName != null) {
      return this.widget.localName!;
    }

    return "unspecified";
  }

  Widget get _icon {
    if (this.widget.speciesName == null && this.widget.localName == null) {
      return Icon(Icons.question_mark);
    }
    ;

    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isSelected = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isSelected = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isSelected = false;
        });
      },
      onTap: this.widget.onTap,
      child: MeliCard(
          elevation: 0,
          borderWidth: 3.0,
          color: MeliColors.white,
          borderColor: this.isSelected ? Colors.black : MeliColors.white,
          child: Column(children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 4,
                            child: Text(this._title,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'Staatliches'))),
                        Expanded(flex: 1, child: this._icon)
                      ]),
                  Text(
                      '${this.widget.date.day}.${this.widget.date.month}.${this.widget.date.year}')
                ],
              ),
            ),
            Container(
                child: Container(
              height: 210,
              decoration: ShapeDecoration(
                image: DecorationImage(
                  image: NetworkImage(this.widget.image),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)),
                ),
              ),
            )),
          ])),
    );
  }
}

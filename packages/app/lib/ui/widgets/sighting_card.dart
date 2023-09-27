// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';

class SightingCard extends StatelessWidget {
  final String? localName;
  final String subtitle;
  final String image;
  final String? speciesName;

  SightingCard(
      {super.key,
      this.localName,
      required this.subtitle,
      required this.image,
      this.speciesName});

  String get _title {
    if (this.speciesName != null) {
      return this.speciesName!;
    }

    if (this.localName != null) {
      return this.localName!;
    }

    return "unspecified";
  }

  Widget get _icon {
    if (this.speciesName == null && this.localName == null) {
      return Icon(Icons.question_mark);
    }
    ;

    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(
        elevation: 0,
        color: MeliColors.white,
        child: Column(children: [
          Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 4, child: Text(this._title)),
                      Expanded(flex: 1, child: this._icon)
                    ]),
                Text(this.subtitle)
              ],
            ),
          ),
          Container(
              child: Container(
            height: 210,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(this.image),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0)),
              ),
            ),
          )),
        ]));
  }
}

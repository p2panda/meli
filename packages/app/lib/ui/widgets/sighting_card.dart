// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/image.dart';

class SightingCard extends StatefulWidget {
  final String? localName;
  final DateTime date;
  final String? imageUrl;
  final String? speciesName;
  final VoidCallback onTap;

  SightingCard(
      {super.key,
      this.localName,
      required this.onTap,
      required this.date,
      required this.imageUrl,
      this.speciesName});

  @override
  State<SightingCard> createState() => _SightingCardState();
}

class _SightingCardState extends State<SightingCard> {
  bool isSelected = false;

  Widget get _title {
    String title = AppLocalizations.of(context)!.sightingUnspecified;

    if (this.widget.speciesName != null) {
      title = widget.localName!;
    } else if (widget.localName != null) {
      title = widget.speciesName!;
    }

    return Text(title,
        style: TextStyle(fontSize: 20.0, fontFamily: 'Staatliches'));
  }

  Widget get _icon {
    if (widget.speciesName == null && widget.localName == null) {
      return Icon(Icons.question_mark);
    }

    return SizedBox.shrink();
  }

  Widget get _date {
    return Text('${widget.date.day}.${widget.date.month}.${widget.date.year}');
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
          borderColor: this.isSelected ? MeliColors.black : MeliColors.white,
          child: Column(children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        this._title,
                        this._icon,
                      ]),
                  this._date,
                ],
              ),
            ),
            Container(
              child: MeliImage(url: this.widget.imageUrl),
              clipBehavior: Clip.hardEdge,
              height: 200.0,
              width: double.infinity,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)),
                ),
              ),
            )
          ])),
    );
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/local_names.dart';
import 'package:app/models/species.dart';
import 'package:app/models/blobs.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/image.dart';

class SightingCard extends StatefulWidget {
  final Blob? image;
  final DateTime date;
  final LocalName? localName;
  final Species? species;

  final VoidCallback onTap;

  SightingCard(
      {super.key,
      this.localName,
      required this.onTap,
      required this.date,
      this.image,
      this.species});

  @override
  State<SightingCard> createState() => _SightingCardState();
}

class _SightingCardState extends State<SightingCard> {
  bool isSelected = false;

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
            SightingCardHeader(
                localName: widget.localName,
                species: widget.species,
                date: widget.date),
            Container(
              child: MeliImage(image: widget.image),
              clipBehavior: Clip.hardEdge,
              height: 200.0,
              width: double.infinity,
              decoration: const ShapeDecoration(
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

class SightingCardHeader extends StatelessWidget {
  final LocalName? localName;
  final Species? species;
  final DateTime date;

  const SightingCardHeader(
      {super.key, this.localName, this.species, required this.date});

  @override
  Widget build(BuildContext context) {
    String title = AppLocalizations.of(context)!.sightingUnspecified;

    if (this.species != null) {
      title = this.species!.species.name;
    } else if (this.localName != null) {
      title = this.localName!.name;
    }

    bool showQuestionMark = this.species == null;

    String date = '${this.date.day}.${this.date.month}.${this.date.year}';

    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title,
                style: TextStyle(fontSize: 20.0, fontFamily: 'Staatliches')),
            if (showQuestionMark) Icon(Icons.question_mark),
          ]),
          Text(date),
        ],
      ),
    );
  }
}

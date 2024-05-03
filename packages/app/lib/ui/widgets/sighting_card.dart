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

  const SightingCard(
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

  Widget get _title {
    String title = AppLocalizations.of(context)!.sightingUnspecified;

    if (widget.species != null) {
      title = widget.species!.species.name;
    } else if (widget.localName != null) {
      title = widget.localName!.name;
    }

    return Text(title,
        style: const TextStyle(fontSize: 20.0, fontFamily: 'Staatliches'));
  }

  Widget get _icon {
    if (widget.species == null) {
      return const Icon(Icons.question_mark);
    }

    return const SizedBox.shrink();
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
      onTap: widget.onTap,
      child: MeliCard(
          elevation: 0,
          borderWidth: 3.0,
          color: MeliColors.white,
          borderColor: isSelected ? MeliColors.black : MeliColors.white,
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
                        _title,
                        _icon,
                      ]),
                  _date,
                ],
              ),
            ),
            Container(
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
              child: MeliImage(image: widget.image),
            )
          ])),
    );
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/blobs.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/screens/species.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/image.dart';
import 'package:app/ui/widgets/pagination_list.dart';

class SightingsTiles extends StatefulWidget {
  final Paginator<Sighting> paginator;
  final OnTap onTap;

  const SightingsTiles(
      {super.key, required this.paginator, required this.onTap});

  @override
  State<SightingsTiles> createState() => _SightingsTilesState();
}

class _SightingsTilesState extends State<SightingsTiles> {
  Widget _item(Sighting sighting) {
    return SightingTile(
        onTap: () => widget.onTap(sighting.id),
        date: sighting.datetime,
        image: sighting.images.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    return PaginationGrid<Sighting>(
        builder: (Sighting sighting) {
          return _item(sighting);
        },
        paginator: widget.paginator);
  }
}

class SightingTile extends StatefulWidget {
  final Blob? image;
  final DateTime date;
  final VoidCallback onTap;

  const SightingTile(
      {super.key, this.image, required this.date, required this.onTap});

  @override
  State<SightingTile> createState() => _SightingTileState();
}

class _SightingTileState extends State<SightingTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
      child: MeliCard(
          borderColor: isSelected ? MeliColors.black : MeliColors.white,
          borderWidth: 3.0,
          child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              child: MeliImage(image: widget.image))),
    );
  }
}

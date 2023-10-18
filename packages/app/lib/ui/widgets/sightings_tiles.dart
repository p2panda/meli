// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/blobs.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/image.dart';
import 'package:app/ui/widgets/pagination_cards_list.dart';

class SightingsTiles extends StatefulWidget {
  final Paginator<Sighting> paginator;

  SightingsTiles({super.key, required this.paginator});

  @override
  State<SightingsTiles> createState() => _SightingsTilesState();
}

class _SightingsTilesState extends State<SightingsTiles> {
  Widget _item(Sighting sighting) {
    return SightingTile(
        onTap: () => router.pushNamed(RoutePaths.sighting.name,
            pathParameters: {'documentId': sighting.id}),
        date: sighting.datetime,
        image: sighting.images.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    return PaginationList<Sighting>(
        builder: (Sighting sighting) {
          return Container(
              padding: EdgeInsets.only(bottom: 20.0),
              child: this._item(sighting));
        },
        paginator: widget.paginator);
  }
}

class SightingTile extends StatelessWidget {
  final Blob? image;
  final DateTime date;
  final VoidCallback onTap;

  const SightingTile(
      {super.key, this.image, required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          constraints: BoxConstraints(maxWidth: 50.0),
          child: MeliImage(image: image));
    });
  }
}

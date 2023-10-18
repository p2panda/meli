// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/pagination_cards_list.dart';
import 'package:app/ui/widgets/sighting_card.dart';

class SightingsList extends StatefulWidget {
  final Paginator<Sighting> paginator;

  SightingsList({super.key, required this.paginator});

  @override
  State<SightingsList> createState() => _SightingsListState();
}

class _SightingsListState extends State<SightingsList> {
  Widget _item(Sighting sighting) {
    return SightingCard(
        onTap: () => router.pushNamed(RoutePaths.sighting.name,
            pathParameters: {'documentId': sighting.id}),
        date: sighting.datetime,
        localName: sighting.localName,
        species: sighting.species,
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

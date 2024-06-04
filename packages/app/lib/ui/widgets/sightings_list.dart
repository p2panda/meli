// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/ui/widgets/refresh_provider.dart';
import 'package:app/ui/widgets/sighting_card.dart';

class SightingsList extends StatefulWidget {
  final Paginator<Sighting> paginator;

  const SightingsList({super.key, required this.paginator});

  @override
  State<SightingsList> createState() => _SightingsListState();
}

class _SightingsListState extends State<SightingsList> {
  Widget _item(Sighting sighting) {
    return SightingCard(
        onTap: () => router.pushNamed(RoutePaths.sighting.name,
                pathParameters: {'documentId': sighting.id}).then((value) {
              final refreshProvider = RefreshProvider.of(context);
              // Refresh list when we've returned from updating or deleting a
              // sighting or species
              if ((refreshProvider.isDirty(RefreshKeys.UpdatedSighting) ||
                      refreshProvider.isDirty(RefreshKeys.DeletedSighting) ||
                      refreshProvider.isDirty(RefreshKeys.UpdatedSpecies) ||
                      refreshProvider.isDirty(RefreshKeys.DeletedSpecies)) &&
                  widget.paginator.refresh != null) {
                widget.paginator.refresh!();
              }
            }),
        date: sighting.datetime,
        localName: sighting.localName,
        species: sighting.species,
        image: sighting.images.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPaginationBase<Sighting>(
        builder: (List<Sighting> collection) {
          return SliverList.builder(
              itemCount: collection.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding: const EdgeInsets.only(
                        bottom: 20.0, left: 20.0, right: 20.0),
                    child: _item(collection[index]));
              });
        },
        paginator: widget.paginator);
  }
}

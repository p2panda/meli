// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/sightings.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/ui/widgets/tag_item.dart';
import 'package:app/ui/widgets/used_for_dedup_tag_list.dart';

class SpeciesUsesAggregate extends StatelessWidget {
  final DocumentId id;

  const SpeciesUsesAggregate({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      child: Column(
        children: [
          MeliCardHeader(
            title: AppLocalizations.of(context)!.usedForCardTitle,
          ),
          SpeciesUsesAggregateList(id: id),
        ],
      ),
    );
  }
}

class SpeciesUsesAggregateList extends StatelessWidget {
  const SpeciesUsesAggregateList({
    super.key,
    required this.id,
  });

  final DocumentId id;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 10, right: 18, bottom: 0, left: 18),
        child: FetchAll(
          paginator: SpeciesSightingsPaginator(id),
          builder: (collection) {
            return UsedForTagsList(sightings: collection);
          },
        ));
  }
}

class UsedForTagsList extends StatelessWidget {
  final List<Sighting> sightings;

  const UsedForTagsList({super.key, required this.sightings});

  @override
  Widget build(BuildContext context) {
    UsedForPaginator paginator = UsedForPaginator(
        sightings: sightings.map((sighting) => sighting.id).toList());

    return DeduplicatedUsedForTagsList(
        builder: (UsedFor usedFor) {
          return TagItem(label: usedFor.usedFor);
        },
        paginator: paginator);
  }
}

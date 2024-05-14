// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/base.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/sightings.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/tag_item.dart';
import 'package:app/ui/widgets/used_for_dedup_tag_list.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_header.dart';

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

  bool _fetchMoreOverride(PaginatedCollection<Sighting> data) {
    // This is preparatory query where we want to get _all_ sightings for the
    // specified species in order to then compose a paginated query over uses
    // filtered by sighting id. We keep fetching more pages until there is no
    // next page.
    return data.hasNextPage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(
                vertical: 10.0, horizontal: 18.0),
            child: PaginationListWrapper(
              paginator: SpeciesSightingsPaginator(id),
              builder: (collection) {
                return UsedForTagsList(sightings: collection);
              },
              fetchMoreOverride: _fetchMoreOverride,
            )),
      ),
    );
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
          return Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: TagItem(label: usedFor.usedFor, onClick: (item) => {}));
        },
        paginator: paginator);
  }
}

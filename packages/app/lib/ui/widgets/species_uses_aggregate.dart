// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/sightings.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/species_uses_list.dart';
import 'package:app/ui/widgets/tag_item.dart';
import 'package:app/ui/widgets/used_for_dedup_tag_list.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_header.dart';

class SpeciesUsesAggregate extends StatelessWidget {
  final DocumentId id;

  const SpeciesUsesAggregate({super.key, required this.id});

  Widget _builder(List<Sighting> collection) {
    return MeliCard(
        elevation: 0,
        borderWidth: 3.0,
        child: DeduplicatedUsedForTagsList(
            builder: (UsedFor usedFor) {
              return Container(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child:
                      TagItem(label: usedFor.usedFor, onClick: (item) => {}));
            },
            paginator: UsedForPaginator(
                sightings:
                    collection.map((sighting) => sighting.id).toList())));
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      child: Column(
        children: [
          MeliCardHeader(
            title: AppLocalizations.of(context)!.usedForCardTitle,
          ),
          Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
              child: SpeciesUsedForList(
                paginator: SpeciesSightingsPaginator(id),
                builder: this._builder,
              )),
        ],
      ),
    );
  }
}

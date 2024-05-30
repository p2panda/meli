// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/local_names.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:app/ui/widgets/local_names_dedup_tag_list.dart';
import 'package:app/ui/widgets/tag_item.dart';

class SpeciesLocalNamesAggregate extends StatelessWidget {
  final DocumentId id;

  const SpeciesLocalNamesAggregate({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      child: Column(
        children: [
          MeliCardHeader(
            title: AppLocalizations.of(context)!.localNamesCardTitle,
          ),
          LocalNamesList(species: id),
        ],
      ),
    );
  }
}

class LocalNamesList extends StatelessWidget {
  const LocalNamesList({
    super.key,
    required this.species,
  });

  final DocumentId species;

  @override
  Widget build(BuildContext context) {
    LocalNamesPaginator paginator = LocalNamesPaginator(species: species);

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: SingleChildScrollView(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            child: DeduplicatedLocalNamesList(
                builder: (LocalName localName) {
                  return Container(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: TagItem(
                          label: localName.name, onClick: (item) => {}));
                },
                paginator: paginator)),
      ),
    );
  }
}

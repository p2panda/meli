// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/species.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/species_field.dart';

class SpeciesScreen extends StatefulWidget {
  final String documentId;

  SpeciesScreen({super.key, required this.documentId});

  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: AppLocalizations.of(context)!.speciesScreenTitle,
        body: Container(
          child: SingleChildScrollView(
            child: Query(
                options: QueryOptions(
                    document: gql(speciesQuery(widget.documentId))),
                builder: (result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return ErrorCard(message: result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                              color: MeliColors.black)),
                    );
                  }

                  final species = Species.fromJson(
                      result.data?['species'] as Map<String, dynamic>);

                  return SpeciesProfile(species);
                }),
          ),
        ));
  }
}

class SpeciesProfile extends StatefulWidget {
  final Species initialValue;

  SpeciesProfile(this.initialValue, {super.key});

  @override
  State<SpeciesProfile> createState() => _SpeciesProfileState();
}

class _SpeciesProfileState extends State<SpeciesProfile> {
  /// Mutable sighting instance. Can be changed by this stateful widget.
  late Species species;

  @override
  void initState() {
    species = widget.initialValue;
    super.initState();
  }

  void _updateSpecies(TaxonomySpecies? taxon) async {
    if (species.species.id == taxon?.id) {
      // Nothing has changed
      return;
    }

    if (taxon == null) {
      // Remove species assignment
      // @TODO
      // await species.update(species: []);
    } else {
      // Assign species, create it before if it doesn't exist yet
      final species = await Species.upsert(taxon);
      // @TODO
      // await species.update(species: [species]);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(runSpacing: 20.0, children: [
        SpeciesField(
          species.species,
          onUpdate: _updateSpecies,
        ),
        // @TODO: Remove this as soon as there are more elements
        SizedBox(height: 550.0),
      ]),
    );
  }
}

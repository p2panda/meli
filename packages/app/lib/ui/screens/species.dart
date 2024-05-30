// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/species_local_names_aggregate.dart';
import 'package:app/ui/widgets/species_uses_aggregate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/sightings.dart';
import 'package:app/models/species.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/sightings_tiles.dart';
import 'package:app/ui/widgets/species_field.dart';
import 'package:app/ui/widgets/text_field.dart';

class SpeciesScreen extends StatefulWidget {
  final String documentId;

  const SpeciesScreen({super.key, required this.documentId});

  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: AppLocalizations.of(context)!.speciesScreenTitle,
        appBarColor: MeliColors.peach,
        body: Query(
            options:
                QueryOptions(document: gql(speciesQuery(widget.documentId))),
            builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return ErrorCard(message: result.exception.toString());
              }

              if (result.isLoading) {
                return const Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child:
                          CircularProgressIndicator(color: MeliColors.black)),
                );
              }

              final species = Species.fromJson(
                  result.data?['species'] as Map<String, dynamic>);

              return SpeciesProfile(species);
            }));
  }
}

class SpeciesProfile extends StatefulWidget {
  final Species initialValue;

  const SpeciesProfile(this.initialValue, {super.key});

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

  Future<void> _updateTaxon(TaxonomySpecies? taxon) async {
    if (species.species.id == taxon?.id) {
      // Nothing has changed
      return;
    } else if (taxon != null) {
      await species.update(species: taxon);
      setState(() {});
    }
  }

  Future<void> _updateDescription(String value) async {
    await species.update(description: value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 0.0, right: 20.0, left: 20.0),
      decoration: const SeaWavesBackground(),
      child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            SpeciesProfileTitle(species.species.name),
            const SizedBox(height: 100.0),
            SpeciesField(
              species.species,
              allowNull: false,
              onUpdate: _updateTaxon,
            ),
            const SizedBox(height: 20.0),
            EditableTextField(species.description,
                title: AppLocalizations.of(context)!.speciesDescription,
                onUpdate: _updateDescription),
            const SizedBox(height: 20.0),
            SpeciesUsesAggregate(id: species.id),
            const SizedBox(height: 20.0),
            SpeciesLocalNamesAggregate(id: species.id),
            const SizedBox(height: 20.0),
          ])),
          RelatedSightings(id: species.id),
          const SliverToBoxAdapter(child: SizedBox(height: 20.0)),
        ],
      ),
    );
  }
}

class RelatedSightings extends StatelessWidget {
  final DocumentId id;

  const RelatedSightings({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final Paginator<Sighting> paginator = SpeciesSightingsPaginator(id);
    return SightingsTiles(paginator: paginator);
  }
}

class SpeciesProfileTitle extends StatelessWidget {
  final String title;

  const SpeciesProfileTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Text(title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
              height: 1.1, fontFamily: 'Staatliches', fontSize: 24.0)),
    ]));
  }
}

class SeaWavesBackground extends Decoration {
  const SeaWavesBackground();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _SeaWavesPainer();
  }
}

class _SeaWavesPainer extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size? bounds = configuration.size;

    final paint = Paint()
      ..color = MeliColors.peach
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(bounds!.width / 2, 100.0);
    path.lineTo(bounds.width, 0.0);
    path.moveTo(0, 0);
    path.lineTo(bounds.width / 6, 70.0);
    path.lineTo(bounds.width, 0.0);
    path.moveTo(0, 0);
    path.lineTo(bounds.width - (bounds.width / 6), 70.0);
    path.lineTo(bounds.width, 0.0);
    path.close();

    canvas.drawPath(path.shift(offset), paint);
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/files.dart';
import 'package:app/models/local_names.dart';
import 'package:app/models/sightings.dart';
import 'package:app/models/species.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/image_carousel.dart';
import 'package:app/ui/widgets/local_name_field.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/species_field.dart';

class SightingScreen extends StatefulWidget {
  final String documentId;

  SightingScreen({super.key, required this.documentId});

  @override
  State<SightingScreen> createState() => _SightingScreenState();
}

class _SightingScreenState extends State<SightingScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: AppLocalizations.of(context)!.sightingScreenTitle,
        backgroundColor: MeliColors.electric,
        appBarColor: MeliColors.electric,
        body: Container(
          child: SingleChildScrollView(
            child: Query(
                options: QueryOptions(
                    document: gql(sightingQuery(widget.documentId))),
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

                  final sighting = Sighting.fromJson(
                      result.data?['sighting'] as Map<String, dynamic>);

                  return SightingProfile(sighting);
                }),
          ),
        ));
  }
}

class SightingProfile extends StatefulWidget {
  final Sighting initialValue;

  SightingProfile(this.initialValue, {super.key});

  @override
  State<SightingProfile> createState() => _SightingProfileState();
}

class _SightingProfileState extends State<SightingProfile> {
  /// Mutable sighting instance. Can be changed by this stateful widget.
  late Sighting sighting;

  @override
  void initState() {
    sighting = widget.initialValue;
    super.initState();
  }

  void _updateLocalName(AutocompleteItem? item) async {
    List<LocalName> localNames = [];
    if (item == null) {
      // Remove local name from sighting
    } else if (item.documentId == null) {
      // Create new local name to assign it then to sighting
      localNames.add(await LocalName.create(name: item.value));
    } else if (item.documentId != null) {
      // Assign existing local name to sighting
      localNames.add(LocalName(
          id: item.documentId!, viewId: item.viewId!, name: item.value));
    }

    await sighting.update(localNames: localNames);
    setState(() {});
  }

  void _updateSpecies(TaxonomySpecies? taxon) async {
    if (sighting.species?.species.id == taxon?.id) {
      // Nothing has changed
      return;
    }

    if (taxon == null) {
      // Remove species assignment
      await sighting.update(species: []);
    } else {
      // Assign species, create it before if it doesn't exist yet
      final species = await Species.upsert(taxon);
      await sighting.update(species: [species]);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = sighting.images
        .map((image) => '${BLOBS_BASE_PATH}/${image.id}')
        .toList();

    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 80.0, bottom: 20.0),
      decoration: const SeaWavesBackground(),
      child: Wrap(runSpacing: 20.0, children: [
        SightingProfileTitle(sighting),
        ImageCarousel(imagePaths: imagePaths),
        LocalNameField(
          sighting.localName,
          onUpdate: _updateLocalName,
        ),
        SpeciesField(
          sighting.species?.species,
          onUpdate: _updateSpecies,
        ),
        // @TODO: Remove this as soon as there are more elements
        SizedBox(height: 550.0),
      ]),
    );
  }
}

class SightingProfileTitle extends StatelessWidget {
  final Sighting sighting;

  SightingProfileTitle(this.sighting, {super.key});

  @override
  Widget build(BuildContext context) {
    List<String> title = [];

    if (sighting.species != null) {
      title.add(sighting.species!.species.name);
    }

    if (sighting.localName != null) {
      title.add('"${sighting.localName!.name}"');
    }

    if (title.isEmpty) {
      title.add(AppLocalizations.of(context)!.sightingUnspecified);
    }

    final id = sighting.id.substring(sighting.id.length - 4);

    final datetime = sighting.datetime;
    final date = '${datetime.day}.${datetime.month}.${datetime.year}';
    final time = '${datetime.hour}:${datetime.minute} ${datetime.timeZoneName}';

    return Center(
        child: Column(children: [
      Text(title.join(' '),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: const TextStyle(
              height: 1.1, fontFamily: 'Staatliches', fontSize: 24.0)),
      const SizedBox(height: 10.0),
      Text('${date} | ${time} | #${id}', style: const TextStyle(fontSize: 16.0))
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
      ..color = MeliColors.sea
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo((bounds!.width / 4) * 1, -50.0);
    path.lineTo((bounds.width / 4) * 2, 0.0);
    path.lineTo((bounds.width / 4) * 3, -50.0);
    path.lineTo((bounds.width / 4) * 4, 0.0);
    path.lineTo(bounds.width, bounds.height);
    path.lineTo(0, bounds.height);
    path.close();

    canvas.drawPath(path.shift(offset).shift(Offset(0, 50.0)), paint);
  }
}

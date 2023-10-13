// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/local_names.dart';
import 'package:app/models/sightings.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/image_carousel.dart';
import 'package:app/ui/widgets/local_name_autocomplete.dart';
import 'package:app/ui/widgets/scaffold.dart';

class SightingScreen extends StatefulWidget {
  final String documentId;

  SightingScreen({super.key, required this.documentId});

  @override
  State<SightingScreen> createState() => _SightingScreenState();
}

class _SightingScreenState extends State<SightingScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: AppLocalizations.of(context)!.sightingScreenTitle,
        backgroundColor: MeliColors.electric,
        appBarColor: MeliColors.electric,
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 80.0),
            decoration: const SeaWavesBackground(),
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

class SightingProfile extends StatelessWidget {
  final Sighting sighting;

  SightingProfile(this.sighting, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 20.0,
      children: [
        SightingProfileTitle(sighting),
        ImageCarousel(
            imagePaths: sighting.images
                .map((image) => 'http://localhost:2020/blobs/${image.id}')
                .toList()),
        LocalNameField(sighting.localName),
      ],
    );
  }
}

class LocalNameField extends StatefulWidget {
  final LocalName? value;

  LocalNameField(this.value, {super.key});

  @override
  State<LocalNameField> createState() => _LocalNameFieldState();
}

class _LocalNameFieldState extends State<LocalNameField> {
  bool isEditMode = false;

  Widget _editable() {
    return LocalNameAutocomplete(onChanged: (AutocompleteItem value) {});
  }

  Widget _readOnly() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 48.0,
      child: Text(widget.value != null ? widget.value!.name : '',
          textAlign: TextAlign.left, style: const TextStyle(fontSize: 16.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditableCard(
        title: AppLocalizations.of(context)!.localNameCardTitle,
        child: isEditMode ? _editable() : _readOnly(),
        onChanged: (bool value) {
          setState(() {
            isEditMode = value;
          });
        });
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
    path.lineTo((bounds!.width / 4) * 1, bounds.height + 50.0);
    path.lineTo((bounds.width / 4) * 2, bounds.height);
    path.lineTo((bounds.width / 4) * 3, bounds.height + 50.0);
    path.lineTo((bounds.width / 4) * 4, bounds.height);
    path.lineTo(0, bounds.height);
    path.close();

    canvas.drawPath(path.shift(Offset(0.0, 50.0)), paint);
  }
}

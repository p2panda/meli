// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
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
  final Sighting sighting;

  SightingProfile(this.sighting, {super.key});

  @override
  State<SightingProfile> createState() => _SightingProfileState();
}

class _SightingProfileState extends State<SightingProfile> {
  late Sighting sighting;

  @override
  void initState() {
    sighting = widget.sighting;
    super.initState();
  }

  void _addLocalName(String name) async {
    final localName = await LocalName.create(name: name);
    await sighting.update(localName: localName);
    setState(() {});
  }

  void _updateLocalName(AutocompleteItem item) async {
    await sighting.update(
        localName: LocalName(
            id: item.documentId!, viewId: item.viewId!, name: item.value));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final imagePaths = sighting.images
        .map((image) => 'http://localhost:2020/blobs/${image.id}')
        .toList();

    return Container(
      padding: const EdgeInsets.only(
          left: 20.0, right: 20.0, top: 80.0, bottom: 20.0),
      decoration: const SeaWavesBackground(),
      child: Wrap(runSpacing: 20.0, children: [
        SightingProfileTitle(sighting),
        ImageCarousel(imagePaths: imagePaths),
        LocalNameField(
          sighting.viewId,
          sighting.localName,
          onCreate: _addLocalName,
          onUpdate: _updateLocalName,
        )
      ]),
    );
  }
}

typedef OnUpdate = void Function(AutocompleteItem);

typedef OnCreate = void Function(String);

class LocalNameField extends StatefulWidget {
  final DocumentViewId viewId;
  final LocalName? current;
  final OnUpdate onUpdate;
  final OnCreate onCreate;

  LocalNameField(this.viewId, this.current,
      {super.key, required this.onUpdate, required this.onCreate});

  @override
  State<LocalNameField> createState() => _LocalNameFieldState();
}

class _LocalNameFieldState extends State<LocalNameField> {
  bool isEditMode = false;
  AutocompleteItem? _dirty;

  void _update() async {
    if (_dirty == null) {
      return;
    }

    if (_dirty!.documentId != null) {
      widget.onUpdate.call(_dirty!);
    } else {
      widget.onCreate.call(_dirty!.value);
    }
  }

  Widget _editable() {
    return LocalNameAutocomplete(
        initialValue: widget.current != null
            ? AutocompleteItem(
                value: widget.current!.name, documentId: widget.current!.id)
            : null,
        onChanged: (AutocompleteItem newValue) {
          if (widget.current == null) {
            _dirty = newValue;
          } else if (widget.current!.name != newValue.value &&
              widget.current!.id != newValue.documentId) {
            _dirty = newValue;
          }
        });
  }

  Widget _readOnly() {
    return Container(
      alignment: Alignment.center,
      height: 48.0,
      child: Text(widget.current != null ? widget.current!.name : '',
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

            if (!isEditMode) {
              _update();
            }
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
    path.lineTo((bounds.width / 4) * 1, bounds.height + 50.0);
    path.lineTo((bounds.width / 4) * 2, bounds.height);
    path.lineTo((bounds.width / 4) * 3, bounds.height + 50.0);
    path.lineTo((bounds.width / 4) * 4, bounds.height);
    path.lineTo(0, bounds.height);
    path.close();

    canvas.drawPath(path.shift(offset).shift(Offset(0, 50.0)), paint);
  }
}

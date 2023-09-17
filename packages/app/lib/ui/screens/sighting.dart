// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/data.dart';

import '../widgets/editable_card.dart';

class SightingScreen extends StatefulWidget {
  final String id;

  SightingScreen({super.key, required this.id});

  @override
  State<SightingScreen> createState() => _SightingScreenState();
}

class _SightingScreenState extends State<SightingScreen> {
  final _formKey = GlobalKey<FormState>();

  Map<String, String> _sighting() {
    return sightings.where((element) => element['id'] == this.widget.id).first;
  }

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Sighting',
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              EditableCard(
                title: 'Name',
                fields: {'Name': this._sighting()['name']!},
              ),
              EditableCard(
                  title: 'Species',
                  fields: {'Species': this._sighting()['species']!}),
              EditableCard(
                  title: 'Image', fields: {'Image': this._sighting()['img']!})
            ],
          ),
        )));
  }
}

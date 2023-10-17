// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/species.dart';

typedef OnUpdate = void Function(AutocompleteItem?);

class SpeciesField extends StatelessWidget {
  final Species? current;
  final OnUpdate onUpdate;

  SpeciesField(this.current, {super.key, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

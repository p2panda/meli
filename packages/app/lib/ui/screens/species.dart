// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/scaffold.dart';

class SpeciesScreen extends StatelessWidget {
  final String documentId;

  SpeciesScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(title: 'Species', body: Text('Nothing here yet'));
  }
}

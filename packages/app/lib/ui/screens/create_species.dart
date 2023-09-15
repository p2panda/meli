// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/species_form.dart';

class CreateSpeciesScreen extends StatefulWidget {
  CreateSpeciesScreen({super.key});

  @override
  State<CreateSpeciesScreen> createState() => _CreateSpeciesScreenState();
}

class _CreateSpeciesScreenState extends State<CreateSpeciesScreen> {
  
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Create Species',
        body: Container(
            padding: EdgeInsets.all(20.0), child: CreateSpeciesForm()));
  }
}

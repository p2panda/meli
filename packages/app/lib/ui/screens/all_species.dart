// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/image_card.dart';
import 'package:app/data.dart';

class AllSpeciesScreen extends StatefulWidget {
  AllSpeciesScreen({super.key});

  @override
  State<AllSpeciesScreen> createState() => _AllSpeciesScreenState();
}

class _AllSpeciesScreenState extends State<AllSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Species',
        fabAlignment: MainAxisAlignment.end,
        body: SpeciesList());
  }
}

class SpeciesList extends StatefulWidget {
  final List<Map<String, String>> data = species;

  SpeciesList({super.key});

  @override
  State<SpeciesList> createState() => _SpeciesListState();
}

class _SpeciesListState extends State<SpeciesList> {
  List<ImageCard> _speciesCards() {
    return this
        .widget
        .data
        .map((species) => ImageCard(
              footer: species['name']!,
              img: species['img']!,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _speciesCards())),
    );
  }
}

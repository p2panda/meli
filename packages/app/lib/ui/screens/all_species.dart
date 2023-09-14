// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/species_card.dart';

class AllSpeciesScreen extends StatefulWidget {
  AllSpeciesScreen({super.key});

  @override
  State<AllSpeciesScreen> createState() => _AllSpeciesScreenState();
}

class _AllSpeciesScreenState extends State<AllSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(title: 'Species', body: SpeciesList());
  }
}

class SpeciesList extends StatefulWidget {
  final List<SpeciesCard> data = [
    new SpeciesCard(
        name: 'Melipona 1',
        img:
            'https://fthmb.tqn.com/SGxhmRQ5AzFN7UTqNC3EzMIwJdQ=/2560x1686/filters:fill(auto,1)/stingless_bees-59c66d7568e1a20014f976cf.jpg'),
    new SpeciesCard(
        name: 'Melipona 2',
        img:
            'https://media.npr.org/assets/img/2018/10/30/bee1_wide-1dead2b859ef689811a962ce7aa6ace8a2a733d7-s1200.jpg'),
    new SpeciesCard(
        name: 'Melipona 3',
        img:
            'https://i.pinimg.com/originals/50/9a/51/509a514607ac20c3c14694537adf346f.jpg')
  ];

  SpeciesList({super.key});

  @override
  State<SpeciesList> createState() => _SpeciesListState();
}

class _SpeciesListState extends State<SpeciesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: this.widget.data)),
    );
  }
}

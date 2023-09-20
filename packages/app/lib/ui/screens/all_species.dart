// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/species_card.dart';
import 'package:app/ui/colors.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      decoration: new BackgroundDecoration(),
      child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
          child:
              Wrap(spacing: 0.0, runSpacing: 20.0, children: _speciesCards())),
    );
  }

  List<SpeciesCard> _speciesCards() {
    return this
        .widget
        .data
        .map((species) =>
            SpeciesCard(title: species['name']!, image: species['img']!))
        .toList();
  }
}

class BackgroundDecoration extends Decoration {
  BackgroundDecoration();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BackgroundDecorationPainter();
  }
}

class _BackgroundDecorationPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size? bounds = configuration.size;

    final paint = Paint()
      ..color = MeliColors.peach
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

    canvas.drawPath(path.shift(Offset(0.0, 130.0)), paint);
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';

class SpeciesCard extends StatefulWidget {
  final DocumentId id;
  final TaxonomySpecies taxonomySpecies;

  final VoidCallback onTap;

  SpeciesCard(
      {super.key,
      required this.id,
      required this.taxonomySpecies,
      required this.onTap});

  @override
  State<SpeciesCard> createState() => _SpeciesCardState();
}

class _SpeciesCardState extends State<SpeciesCard> {
  bool isSelected = false;

  Widget get _title {
    return Text(
      this.widget.taxonomySpecies.name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget get _image {
    // @TODO: Try to get at least one image associated with this species via GraphQL
    return Text('@TODO');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          isSelected = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          isSelected = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isSelected = false;
        });
      },
      onTap: this.widget.onTap,
      child: MeliCard(
          elevation: 0,
          borderWidth: 0.0,
          color: MeliColors.white,
          borderColor: this.isSelected ? MeliColors.black : MeliColors.white,
          child: Column(children: [
            Container(
              child: this._image,
              clipBehavior: Clip.hardEdge,
              height: 240.0,
              width: double.infinity,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 6.0,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 6.0, bottom: 10.0, left: 6.0),
              alignment: AlignmentDirectional.center,
              child: this._title,
            ),
          ])),
    );
  }
}

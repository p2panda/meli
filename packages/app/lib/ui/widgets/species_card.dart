// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/sightings.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/image.dart';

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
        fontSize: 30.0,
        fontFamily: 'Staatliches',
      ),
    );
  }

  Widget get _image {
    return Query(
      options: QueryOptions(
        document: gql(lastSightingQuery(widget.id)),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return MeliImage(
              image: null, externalError: result.exception.toString());
        }

        if (result.isLoading) {
          return SizedBox.shrink();
        }

        final list = result.data![DEFAULT_RESULTS_KEY]['documents'] as List;
        if (list.isNotEmpty) {
          Sighting sighting =
              Sighting.fromJson(list.first as Map<String, dynamic>);
          return MeliImage(image: sighting.images.first);
        } else {
          return MeliImage(image: null);
        }
      },
    );
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

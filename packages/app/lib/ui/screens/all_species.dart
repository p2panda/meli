// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/pagination_cards_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/base.dart';
import 'package:app/models/species.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/species_card.dart';

class AllSpeciesScreen extends StatelessWidget {
  final Paginator<Species> paginator = SpeciesPaginator();

  AllSpeciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: AppLocalizations.of(context)!.allSpeciesScreenTitle,
        body: RefreshIndicator(
            color: MeliColors.black,
            onRefresh: () {
              if (paginator.refresh != null) {
                paginator.refresh!();
              }

              return Future.delayed(const Duration(milliseconds: 150));
            },
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                decoration: const PeachWavesBackground(),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 80.0, bottom: 20.0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SpeciesList(paginator: paginator),
                ),
              );
            })));
  }
}

class SpeciesList extends StatefulWidget {
  final Paginator<Species> paginator;

  const SpeciesList({super.key, required this.paginator});

  @override
  State<SpeciesList> createState() => _SpeciesListState();
}

class _SpeciesListState extends State<SpeciesList> {
  Widget _item(Species species) {
    return SpeciesCard(
        onTap: () => {
              router.pushNamed(RoutePaths.species.name,
                  pathParameters: {'documentId': species.id})
            },
        taxonomySpecies: species.species,
        id: species.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
        child: PaginationList<Species>(
            builder: (Species species) {
              return Container(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _item(species));
            },
            paginator: widget.paginator));
  }
}

class PeachWavesBackground extends Decoration {
  const PeachWavesBackground();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _PeachWavesPainter();
  }
}

class _PeachWavesPainter extends BoxPainter {
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

    canvas.drawPath(path.shift(const Offset(0.0, 160.0)), paint);
  }
}

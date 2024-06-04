// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/base.dart';
import 'package:app/models/species.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/ui/widgets/refresh_provider.dart';
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
                child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 80.0)),
                      SpeciesList(paginator: paginator),
                      const SliverToBoxAdapter(child: SizedBox(height: 20.0)),
                    ]),
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
                  pathParameters: {'documentId': species.id}).then((value) {
                // Refresh list after returning from updating or deleting a species
                final refreshProvider = RefreshProvider.of(context);
                final updated =
                    refreshProvider.isDirty(RefreshKeys.UpdatedSpecies);
                final deleted =
                    refreshProvider.isDirty(RefreshKeys.DeletedSpecies);

                if ((updated || deleted) && widget.paginator.refresh != null) {
                  widget.paginator.refresh!();
                }
              })
            },
        taxonomySpecies: species.species,
        id: species.id);
  }

  @override
  Widget build(BuildContext context) {
    return SliverPaginationBase<Species>(
        builder: (List<Species> collection) {
          return SliverList.builder(
              itemCount: collection.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _item(collection[index]));
              });
        },
        paginator: widget.paginator);
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

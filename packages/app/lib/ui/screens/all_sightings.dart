// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/sighting_card.dart';

class AllSightingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
      floatingActionButtons: [
        MeliFloatingActionButton(
            icon: Icon(Icons.hive_outlined),
            backgroundColor: MeliColors.peach,
            onPressed: () {
              router.push(RoutePaths.allSpecies.path);
            }),
        MeliFloatingActionButton(
            icon: Icon(Icons.camera_alt_outlined),
            backgroundColor: MeliColors.sea,
            onPressed: () {
              router.push(RoutePaths.createSighting.path);
            }),
      ],
      body: Container(
          child: Container(
              decoration: new GreenGradientBackground(),
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                child: ScrollView(),
              ))),
    );
  }
}

class ScrollView extends StatelessWidget {
  final Paginator<Sighting> paginator = SightingPaginator();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: MeliColors.black,
      onRefresh: () {
        if (paginator.refresh != null) {
          paginator.refresh!();
        }

        return Future.delayed(Duration(milliseconds: 150));
      },
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            TopBar(),
            BouncyBee(),
            SizedBox(height: 30.0),
            SightingsList(paginator: this.paginator),
            SizedBox(height: 40.0),
          ])),
    );
  }
}

class SightingsList extends StatefulWidget {
  final Paginator<Sighting> paginator;

  SightingsList({super.key, required this.paginator});

  @override
  State<SightingsList> createState() => _SightingsListState();
}

class _SightingsListState extends State<SightingsList> {
  Widget _item(Sighting sighting) {
    return SightingCard(
        onTap: () => router.pushNamed(RoutePaths.sighting.name,
            pathParameters: {'documentId': sighting.id}),
        date: sighting.datetime,
        localName: sighting.localName,
        species: sighting.species,
        image: sighting.images.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: new MagnoliaWavesBackground(),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: PaginationList<Sighting>(
              builder: (Sighting sighting) {
                return Container(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: this._item(sighting));
              },
              paginator: widget.paginator)),
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      alignment: Alignment.centerRight,
      child: IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: () {
            router.push(RoutePaths.settings.path);
          }),
    );
  }
}

class BouncyBee extends StatefulWidget {
  BouncyBee({super.key});

  @override
  State<BouncyBee> createState() => _BouncyBeeState();
}

class _BouncyBeeState extends State<BouncyBee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _beeAnimationController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );

  late final Animation<Offset> _flyingBeeAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, -0.8),
  ).animate(CurvedAnimation(
    parent: _beeAnimationController,
    curve: ElasticInOutCurve(0.5),
  ));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _beeAnimationController.forward();
      },
      onTapUp: (details) {
        _beeAnimationController.reverse();
      },
      onTapCancel: () {
        _beeAnimationController.reverse();
      },
      child: SlideTransition(
        position: _flyingBeeAnimation,
        child: Center(child: Text("🐝", style: TextStyle(fontSize: 50.0))),
      ),
    );
  }
}

class GreenGradientBackground extends Decoration {
  GreenGradientBackground();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GreenGradientPainter();
  }
}

class _GreenGradientPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size? bounds = configuration.size;

    final paint = Paint()
      ..shader = new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          MeliColors.electric,
          MeliColors.grass.withAlpha(0),
        ],
      ).createShader(Rect.fromCenter(
          center: Offset(bounds!.width / 2, 200.0),
          width: bounds.width,
          height: 200.0))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo((bounds.width / 8) * 1, 30.0);
    path.lineTo((bounds.width / 8) * 2, 0.0);
    path.lineTo((bounds.width / 8) * 4, 50.0);
    path.lineTo((bounds.width / 8) * 6, 0.0);
    path.lineTo((bounds.width / 8) * 7, 30.0);
    path.lineTo((bounds.width / 8) * 8, 0.0);
    path.lineTo(bounds.width, bounds.height);
    path.lineTo(0, bounds.height);
    path.close();

    canvas.drawPath(path.shift(offset + Offset(0, 80.0)), paint);
  }
}

class MagnoliaWavesBackground extends Decoration {
  MagnoliaWavesBackground();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MagnoliaWavesPainer();
  }
}

class _MagnoliaWavesPainer extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size? bounds = configuration.size;

    final paint = Paint()
      ..color = MeliColors.magnolia
      ..style = PaintingStyle.fill;

    final partial = bounds!.width / 8;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(partial, -10.0);
    path.lineTo(partial * 2, 10.0);
    path.lineTo(partial * 4, -20.0);
    path.lineTo(partial * 6, 10.0);
    path.lineTo(partial * 7, -10.0);
    path.lineTo(bounds.width, 0);
    path.lineTo(bounds.width, bounds.height);
    path.lineTo(bounds.width / 2, bounds.height - 20.0);
    path.lineTo(0, bounds.height);
    path.close();

    canvas.drawPath(path.shift(offset), paint);
  }
}

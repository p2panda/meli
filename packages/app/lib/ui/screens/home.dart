// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/scaffold.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
      floatingActionButtons: [
        MeliFloatingActionButton(
            heroTag: 'all_species',
            icon: Icon(Icons.hive_outlined),
            onPressed: () {
              router.push(RoutePath.allSpecies);
            }),
        MeliFloatingActionButton(
            heroTag: 'create_new',
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: () {
              router.push(RoutePath.createNew);
            }),
      ],
      body: Container(
          child: Container(
              decoration: new BackgroundDecoration(),
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                child: ScrollView(),
              ))),
    );
  }
}

class ScrollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: [
      Settings(),
      Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: BouncyBee(),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 100.0),
        child: SightingsList(),
      )
    ]));
  }
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      alignment: Alignment.centerRight,
      child: IconButton(
          icon: Icon(Icons.settings_outlined),
          onPressed: () {
            router.push('/settings');
          }),
    );
  }
}

class SightingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: MeliColors.magnolia,
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
          Card(
              child: Container(
                  padding: const EdgeInsets.all(20.0), child: Text("Hello"))),
        ]));
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
    duration: const Duration(seconds: 2),
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
      child: SlideTransition(
        position: _flyingBeeAnimation,
        child: Center(child: Text("🐝", style: TextStyle(fontSize: 50.0))),
      ),
    );
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
      ..shader = new LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          MeliColors.electric,
          MeliColors.grass,
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

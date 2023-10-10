// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/sighting_card.dart';

class AllSightingsScreen extends StatefulWidget {
  AllSightingsScreen({super.key});

  @override
  State<AllSightingsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AllSightingsScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
      floatingActionButtons: [
        MeliFloatingActionButton(
            heroTag: 'all_species',
            icon: Icon(Icons.hive_outlined),
            onPressed: () {
              router.push(RoutePaths.allSpecies.path);
            }),
        MeliFloatingActionButton(
            heroTag: 'create_new',
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: () {
              router.push(RoutePaths.createSighting.path);
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
        padding: EdgeInsets.only(bottom: 30.0),
        child: BouncyBee(),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 40.0),
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
            router.push(RoutePaths.settings.path);
          }),
    );
  }
}

class SightingsList extends StatefulWidget {
  SightingsList({super.key});

  @override
  State<SightingsList> createState() => _SightingsListState();
}

class _SightingsListState extends State<SightingsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: new SightingsListDecoration(),
      child: Container(
          padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: Query(
              options: QueryOptions(document: gql(allSightingsQuery(null))),
              builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading && result.data == null) {
                  return const Text('Loading ...');
                }

                final data = PaginatedSightingList.fromJson(
                    result.data?['sightings'] as Map<String, dynamic>);

                FetchMoreOptions opts = FetchMoreOptions(
                  document: gql(allSightingsQuery(data.endCursor)),
                  updateQuery: (previousResultData, fetchMoreResultData) {
                    // this function will be called so as to combine both the original and fetchMore results
                    // it allows you to combine them as you would like
                    final List<dynamic> documents = [
                      ...previousResultData?['sightings']['documents']
                          as List<dynamic>,
                      ...fetchMoreResultData?['sightings']['documents']
                          as List<dynamic>
                    ];

                    // to avoid a lot of work, lets just update the list of repos in returned
                    // data with new data, this also ensures we have the endCursor already set
                    // correctly
                    fetchMoreResultData?['sightings']['documents'] = documents;

                    return fetchMoreResultData;
                  },
                );

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ...data.sightings.map((sighting) => GestureDetector(
                          onTap: () => {
                                router.pushNamed(RoutePaths.sighting.name,
                                    pathParameters: {'documentId': sighting.id})
                              },
                          child: SightingCard(
                              subtitle:
                                  '${sighting.datetime.day}.${sighting.datetime.month}.${sighting.datetime.year}',
                              localName: sighting.local_name,
                              speciesName: sighting.species,
                              image: (sighting.images.firstOrNull != null)
                                  ? 'http://localhost:2020/blobs/${sighting.images.first}'
                                  // TODO: remove this placeholder
                                  : 'https://media.npr.org/assets/img/2018/10/30/bee1_wide-1dead2b859ef689811a962ce7aa6ace8a2a733d7-s1200.jpg'))),
                      if (data.hasNextPage)
                        TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Load More"),
                            ],
                          ),
                          onPressed: () {
                            fetchMore!(opts);
                          },
                        )
                    ]);
              })),
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

class SightingsListDecoration extends Decoration {
  SightingsListDecoration();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _SightingsListDecoration();
  }
}

class _SightingsListDecoration extends BoxPainter {
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

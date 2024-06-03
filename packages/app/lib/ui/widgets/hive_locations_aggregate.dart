// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/location.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:app/ui/widgets/counter.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/hive_location_field.dart';

class HiveLocationsAggregate extends StatelessWidget {
  final DocumentId id;

  const HiveLocationsAggregate({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MeliCard(
      child: Column(
        children: [
          MeliCardHeader(
            title: t.hiveLocationCardTitle,
          ),
          FutureBuilder<AggregatedHiveLocations>(
              future: getAggregatedHiveLocations(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                      child: Container(
                          padding: const EdgeInsets.all(30.0),
                          child: const CircularProgressIndicator(
                            color: MeliColors.black,
                          )));
                }

                if (snapshot.hasError) {
                  return ErrorCard(message: snapshot.error.toString());
                }

                final data = snapshot.data!;

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
                  child: Column(
                    children: [
                      HiveLocationAggregateItem(
                          icon: BOX_ICON,
                          title: t.hiveLocationBox,
                          counter: data.boxCounter),
                      const SizedBox(height: 20.0),
                      HiveLocationAggregateItem(
                          icon: BUILDING_ICON,
                          title: t.hiveLocationBuilding,
                          counter: data.buildingCounter),
                      const SizedBox(height: 20.0),
                      HiveLocationAggregateItem(
                          icon: GROUND_ICON,
                          title: t.hiveLocationGround,
                          counter: data.groundCounter),
                      const SizedBox(height: 20.0),
                      HiveLocationAggregateItem(
                          icon: TREE_ICON,
                          title: t.hiveLocationTree,
                          counter: data.treeCounter,
                          child: const Text('test')),
                    ],
                  ),
                );
              })
        ],
      ),
    );
  }
}

class HiveLocationAggregateItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int counter;
  final Widget? child;

  const HiveLocationAggregateItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.counter,
      this.child});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(icon, size: 40, color: MeliColors.black),
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10.0,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (counter > 0) Counter(counter)
            ],
          ),
          if (counter == 0)
            Text(t.hiveLocationsAggregateNoData)
          else if (child != null)
            child!,
        ],
      ))
    ]);
  }
}

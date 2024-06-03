// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:app/ui/widgets/counter.dart';
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 13),
            child: Column(
              children: [
                HiveLocationAggregateItem(
                    icon: BOX_ICON,
                    title: t.hiveLocationBox,
                    counter: 0,
                    child: const Text('test')),
                const SizedBox(height: 20.0),
                HiveLocationAggregateItem(
                    icon: BUILDING_ICON,
                    title: t.hiveLocationBuilding,
                    counter: 0,
                    child: const Text('test')),
                const SizedBox(height: 20.0),
                HiveLocationAggregateItem(
                    icon: GROUND_ICON,
                    title: t.hiveLocationGround,
                    counter: 0,
                    child: const Text('test')),
                const SizedBox(height: 20.0),
                HiveLocationAggregateItem(
                    icon: TREE_ICON,
                    title: t.hiveLocationTree,
                    counter: 0,
                    child: const Text('test')),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class HiveLocationAggregateItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int counter;
  final Widget child;

  const HiveLocationAggregateItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.counter,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(icon, size: 40, color: MeliColors.plum),
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
          counter == 0 ? Text(t.hiveLocationsAggregateNoData) : child,
        ],
      ))
    ]);
  }
}

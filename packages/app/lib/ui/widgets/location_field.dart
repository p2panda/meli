// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/location.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/error_card.dart';

class LocationField extends StatelessWidget {
  final DocumentId sightingId;

  const LocationField({super.key, required this.sightingId});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return EditableCard(
        title: t.allSpeciesScreenTitle,
        onChanged: () {},
        child: Query(
            options: QueryOptions(document: gql(locationQuery(sightingId))),
            builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                return ErrorCard(message: result.exception.toString());
              }

              if (result.isLoading) {
                return const Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child:
                          CircularProgressIndicator(color: MeliColors.black)),
                );
              }

              Location? location =
                  getLocationFromResults(result.data as Map<String, dynamic>);

              return LocationFieldInner(initialValue: location);
            }));
  }
}

class LocationFieldInner extends StatefulWidget {
  final Location? initialValue;

  const LocationFieldInner({super.key, required this.initialValue});

  @override
  State<LocationFieldInner> createState() => _LocationFieldInnerState();
}

class _LocationFieldInnerState extends State<LocationFieldInner> {
  late Location? location;

  @override
  void initState() {
    location = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("TODO");
  }
}

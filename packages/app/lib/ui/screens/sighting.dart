// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../models/sightings.dart';
import '../widgets/editable_card.dart';

class SightingScreen extends StatefulWidget {
  final String id;

  SightingScreen({super.key, required this.id});

  @override
  State<SightingScreen> createState() => _SightingScreenState();
}

class _SightingScreenState extends State<SightingScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Sighting',
        body: SingleChildScrollView(
            child: Query(
                options: QueryOptions(
                    document: gql(sightingQuery(this.widget.id)),
                    pollInterval: const Duration(seconds: 1)),
                builder: (result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Text('Loading ...');
                  }

                  // TODO: I'm not using this data we get back from the node at the moment.
                  Map<String, dynamic> sightingJson =
                      result.data?['sighting'] as Map<String, dynamic>;

                  final sighting = Sighting.fromJson(sightingJson);

                  return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        EditableCard(
                          title: 'Name',
                          fields: {'Name': sighting.name},
                        ),
                        EditableCard(
                            title: 'Species',
                            fields: {'Species': sighting.species}),
                        EditableCard(
                            title: 'Image', fields: {'Image': sighting.img})
                      ],
                    ),
                  );
                })));
  }
}

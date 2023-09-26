// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/sightings.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/scaffold.dart';

class SightingScreen extends StatefulWidget {
  final String documentId;

  SightingScreen({super.key, required this.documentId});

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
                    document: gql(sightingQuery(this.widget.documentId)),
                    pollInterval: const Duration(seconds: 1)),
                builder: (result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Text('Loading ...');
                  }

                  final sighting = Sighting.fromJson(
                      result.data?['sighting'] as Map<String, dynamic>);

                  return Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        EditableCard(
                          title: 'Name',
                          fields: {'Name': sighting.datetime.toString()},
                        ),
                        EditableCard(
                            title: 'Comment',
                            fields: {'Comment': sighting.comment})
                      ],
                    ),
                  );
                })));
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/base.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/models/local_names.dart';
import 'package:app/ui/widgets/autocomplete.dart';

typedef OnChanged = void Function(AutocompleteItem);

class LocalNameAutocomplete extends StatefulWidget {
  final OnChanged onChanged;
  final AutocompleteItem? initialValue;

  LocalNameAutocomplete(
      {super.key, required this.onChanged, this.initialValue});

  @override
  State<LocalNameAutocomplete> createState() => _LocalNameAutocompleteState();
}

class _LocalNameAutocompleteState extends State<LocalNameAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MeliAutocomplete(
        onChanged: widget.onChanged,
        initialValue: widget.initialValue,
        onOptionsRequest: (String value) async {
          try {
            final QueryResult result = await client.query(
                QueryOptions(document: gql(searchLocalNamesQuery(value))));

            if (result.hasException) {
              throw result.exception!;
            }

            final List<dynamic> documents =
                result.data![DEFAULT_RESULTS_KEY]['documents'] as List<dynamic>;

            final List<AutocompleteItem> options = documents.map((document) {
              final localName =
                  LocalName.fromJson(document as Map<String, dynamic>);
              return AutocompleteItem(
                  value: localName.name,
                  documentId: localName.id,
                  viewId: localName.viewId);
            }).toList();

            return options;
          } catch (error) {
            print(error.toString());
            return [];
          }
        });
  }
}

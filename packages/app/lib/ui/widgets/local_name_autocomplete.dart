// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/models/base.dart';
import 'package:app/models/local_names.dart';
import 'package:app/ui/widgets/autocomplete.dart';

typedef OnChanged = void Function(AutocompleteItem);
typedef OnSubmit = void Function(AutocompleteItem);

class LocalNameAutocomplete extends StatefulWidget {
  final OnChanged onChanged;
  final VoidCallback? onSubmit;
  final AutocompleteItem? initialValue;
  final bool autofocus;

  const LocalNameAutocomplete(
      {super.key,
      required this.onChanged,
      this.onSubmit,
      this.autofocus = false,
      this.initialValue});

  @override
  State<LocalNameAutocomplete> createState() => _LocalNameAutocompleteState();
}

class _LocalNameAutocompleteState extends State<LocalNameAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MeliAutocomplete(
        onChanged: widget.onChanged,
        onSubmit: widget.onSubmit,
        initialValue: widget.initialValue,
        autofocus: widget.autofocus,
        onOptionsRequest: (String value) async {
          try {
            final QueryResult result = await client.query(
                QueryOptions(document: gql(searchLocalNamesQuery(value))));

            if (result.hasException) {
              throw result.exception!;
            }

            final List<dynamic> documents =
                result.data![DEFAULT_RESULTS_KEY]['documents'] as List<dynamic>;

            final List<AutocompleteItem> options = [];
            Set<String> seen = {};

            for (var document in documents) {
              final localName =
                  LocalName.fromJson(document as Map<String, dynamic>);

              // De-duplicate results with same "name" value
              if (seen.contains(localName.name)) {
                continue;
              }

              seen.add(localName.name);
              options.add(AutocompleteItem(
                  value: localName.name,
                  documentId: localName.id,
                  viewId: localName.viewId));
            }

            return options.toList();
          } catch (error) {
            print(error.toString());
            return [];
          }
        });
  }
}

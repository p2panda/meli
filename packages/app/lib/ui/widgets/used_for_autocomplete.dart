// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/used_for.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/models/base.dart';
import 'package:app/ui/widgets/autocomplete.dart';

typedef OnChanged = void Function(AutocompleteItem);
typedef OnSubmit = void Function(AutocompleteItem);

class UsedForAutocomplete extends StatefulWidget {
  final OnChanged onChanged;
  final VoidCallback? onSubmit;
  final AutocompleteItem? initialValue;
  final bool autofocus;

  UsedForAutocomplete(
      {super.key,
      required this.onChanged,
      this.onSubmit,
      this.autofocus = false,
      this.initialValue});

  @override
  State<UsedForAutocomplete> createState() => _UsedForAutocompleteState();
}

class _UsedForAutocompleteState extends State<UsedForAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MeliAutocomplete(
        onChanged: widget.onChanged,
        onSubmit: widget.onSubmit,
        initialValue: widget.initialValue,
        autofocus: widget.autofocus,
        dedup: false,
        onOptionsRequest: (String value) async {
          try {
            final QueryResult result = await client
                .query(QueryOptions(document: gql(searchUsedForQuery(value))));

            if (result.hasException) {
              throw result.exception!;
            }

            final List<dynamic> documents =
                result.data![DEFAULT_RESULTS_KEY]['documents'] as List<dynamic>;

            final List<AutocompleteItem> options = documents.map((document) {
              final usedFor =
                  UsedFor.fromJson(document as Map<String, dynamic>);
              return AutocompleteItem(
                  value: usedFor.usedFor,
                  documentId: usedFor.id,
                  viewId: usedFor.viewId);
            }).toList();

            return options;
          } catch (error) {
            print(error.toString());
            return [];
          }
        });
  }
}

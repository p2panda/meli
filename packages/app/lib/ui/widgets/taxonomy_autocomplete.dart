// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/models/base.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/widgets/autocomplete.dart';

typedef OnChanged = void Function(AutocompleteItem);
typedef OnSubmit = void Function(AutocompleteItem);

class TaxonomyAutocomplete extends StatefulWidget {
  final SchemaId schemaId;
  final OnChanged onChanged;
  final VoidCallback? onSubmit;
  final AutocompleteItem? initialValue;

  const TaxonomyAutocomplete(
      {super.key,
      required this.onChanged,
      required this.schemaId,
      this.onSubmit,
      this.initialValue});

  @override
  State<TaxonomyAutocomplete> createState() => _TaxonomyAutocompleteState();
}

class _TaxonomyAutocompleteState extends State<TaxonomyAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MeliAutocomplete(
        onChanged: widget.onChanged,
        onSubmit: widget.onSubmit,
        initialValue: widget.initialValue,
        onOptionsRequest: (String value) async {
          try {
            final QueryResult result = await client.query(QueryOptions(
                document: gql(searchTaxon(widget.schemaId, value))));

            if (result.hasException) {
              throw result.exception!;
            }

            final List<dynamic> documents =
                result.data![DEFAULT_RESULTS_KEY]['documents'] as List<dynamic>;

            final List<AutocompleteItem> options = documents.map((document) {
              final result = BaseTaxonomy.fromJson(
                  widget.schemaId, document as Map<String, dynamic>);
              return AutocompleteItem(
                  value: result.name,
                  documentId: result.id,
                  viewId: result.viewId);
            }).toList();

            return options;
          } catch (error) {
            print(error.toString());
            return [];
          }
        });
  }
}

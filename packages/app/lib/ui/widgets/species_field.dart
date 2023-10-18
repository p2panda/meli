// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/graphql/queries.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/species.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';
import 'package:app/ui/widgets/taxonomy_autocomplete.dart';

typedef OnUpdate = void Function(List<AutocompleteItem?>);

class SpeciesField extends StatefulWidget {
  final Species? current;
  final OnUpdate onUpdate;

  SpeciesField(this.current, {super.key, required this.onUpdate});

  @override
  State<SpeciesField> createState() => _SpeciesFieldState();
}

class _SpeciesFieldState extends State<SpeciesField> {
  /// Current values of this taxonomy including 9 ranks (from "Species"
  /// to "Kingdom").
  List<AutocompleteItem?> _taxonomy = List.filled(9, null, growable: false);

  /// Human-readable labels and assigned p2panda schema ids for each of the 9
  /// ranks in the taxonomy.
  List<Map<String, String>> get _taxonomySettings {
    final t = AppLocalizations.of(context)!;

    return [
      {
        'label': t.taxonomySpecies,
        'field': 'species',
        'schemaId': SchemaIds.taxonomy_species
      },
      {
        'label': t.taxonomyGenus,
        'field': 'genus',
        'schemaId': SchemaIds.taxonomy_genus
      },
      {
        'label': t.taxonomyTribe,
        'field': 'tribe',
        'schemaId': SchemaIds.taxonomy_tribe
      },
      {
        'label': t.taxonomySubfamily,
        'field': 'subfamily',
        'schemaId': SchemaIds.taxonomy_subfamily
      },
      {
        'label': t.taxonomyFamily,
        'field': 'family',
        'schemaId': SchemaIds.taxonomy_family
      },
      {
        'label': t.taxonomyOrder,
        'field': 'order',
        'schemaId': SchemaIds.taxonomy_order
      },
      {
        'label': t.taxonomyClass,
        'field': 'class',
        'schemaId': SchemaIds.taxonomy_class
      },
      {
        'label': t.taxonomyPhylum,
        'field': 'phylum',
        'schemaId': SchemaIds.taxonomy_phylum
      },
      {
        'label': t.taxonomyKingdom,
        'field': 'kingdom',
        'schemaId': SchemaIds.taxonomy_kingdom
      },
    ];
  }

  /// Flag indicating if we're currently editing or not.
  bool _isEditMode = false;

  /// Which ranks are shown to the user.
  int _showUpToRank = 1;

  @override
  void initState() {
    if (widget.current != null) {
      // Populate current state with full taxonomy when a species was defined
      _requestTaxonomy(0, widget.current!.species.id);
    }

    super.initState();
  }

  void _requestTaxonomy(int fromRank, DocumentId id) async {
    try {
      final json = await query(query: getTaxonomy(fromRank, id));
      _populateTaxonomy(json);
    } catch (error) {
      print('Taxonomy data could not be parsed: ${error}');
    }
  }

  void _populateTaxonomy(Map<String, dynamic> json) async {
    // Start with the root of the GraphQL response which is the "Species" rank
    var document = json[DEFAULT_RESULTS_KEY]! as Map<String, dynamic>;

    // Iterate through all ranks and fill in the values into our current state
    // by converting the GraphQL response into autocomplete items.
    for (final (index, rank) in _taxonomySettings.indexed) {
      // Parse and set the current state for this rank
      final parsed = BaseTaxonomy.fromJson(rank['schemaId']!, document);
      _taxonomy[index] = AutocompleteItem(
          value: parsed.name, documentId: parsed.id, viewId: parsed.viewId);

      // Prepare data for the following rank
      document = document['fields']![rank['field']!]! as Map<String, dynamic>;
    }
  }

  void _submit() async {
    // @TODO
    print('submit');
    widget.onUpdate.call(_taxonomy);
  }

  void _validate() {
    if (_taxonomy[0] == null) {
      // Nothing was changed, all good
      return;
    }

    if (_taxonomy[0] != null && _taxonomy[0]!.value == '') {
      // Species field is empty which indicates that user wants to remove it.
      // All good here as well!
      return;
    }

    // Make sure that new taxons can only be followed by _only_ existing or
    // _only_ new ones. Null fields are not allowed _ever_.
    //
    // For example this is a valid input:
    //
    // * Species: <new value>
    // * Genus: <new value>
    // * Tribe: <existing value>
    // * .. followed by many more existing values until end
    //
    // This would be an _invalid_ input:
    //
    // * Species: <new value>
    // * Genus: <existing value>
    // * Tribe: <new value> ! We can't change the tribe of an existing genus !
    bool isInNewRange = _taxonomy[0]!.documentId == null;

    for (final rank in _taxonomy) {
      if (rank == null) {
        // Every rank needs to be defined, either by a new value or an already
        // existing one!
        throw '@TODO';
      }

      if (rank.documentId != null) {
        isInNewRange = false;
      }

      if (!isInNewRange && rank.documentId == null) {
        // We do not allow defining new items _after_ existing ones, the parents
        // of existing ranks are unchangeable!
        throw '@TODO';
      }
    }
  }

  void _toggleEditMode() {
    setState(() {
      try {
        _validate();
      } catch (error) {
        // @TODO: Show message here to user
        print('Invalid: ${error}');
        return;
      }

      _isEditMode = !_isEditMode;

      // If we flip from edit mode to read-only mode we interpret this as a
      // "submit" action by the user
      if (!_isEditMode) {
        _submit();
      }
    });
  }

  Widget _editableValue() {
    final settings = _taxonomySettings;
    final Iterable<Widget> ranks = settings.indexed.map((item) {
      final index = item.$1;
      final rank = item.$2;

      return Rank(
        rank['label']!,
        rank['schemaId']!,
        _taxonomy[index],
        onChanged: (AutocompleteItem value) {
          // Set current state to the edited value
          _taxonomy[index] = value;

          if (index == settings.length - 1) {
            return;
          }

          if (value.documentId == null && value.value != '') {
            // Show next editable rank when new taxon was given by user
            setState(() {
              _showUpToRank = index + 2;
            });
          } else {
            // .. otherwise hide next editable rank
            setState(() {
              _showUpToRank = index + 1;
            });
          }
        },
      );
    });

    return Wrap(
        runSpacing: 20.0, children: ranks.toList().sublist(0, _showUpToRank));
  }

  @override
  Widget build(BuildContext context) {
    String? displayValue =
        widget.current == null ? null : widget.current!.species.name;

    return EditableCard(
        title: AppLocalizations.of(context)!.speciesCardTitle,
        isEditMode: _isEditMode,
        child: _isEditMode ? _editableValue() : ReadOnlyValue(displayValue),
        onChanged: _toggleEditMode);
  }
}

typedef OnChanged = void Function(AutocompleteItem);

class Rank extends StatefulWidget {
  final SchemaId schemaId;
  final AutocompleteItem? current;
  final String title;
  final OnChanged onChanged;

  Rank(this.title, this.schemaId, this.current,
      {super.key, required this.onChanged});

  @override
  State<Rank> createState() => _RankState();
}

class _RankState extends State<Rank> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.title),
      TaxonomyAutocomplete(
          schemaId: widget.schemaId,
          initialValue: widget.current,
          onSubmit: () {
            // @TODO
          },
          onChanged: (AutocompleteItem value) {
            widget.onChanged.call(value);
          }),
    ]);
  }
}

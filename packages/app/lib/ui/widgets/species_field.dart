// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/graphql/queries.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/taxonomy_species.dart';
import 'package:app/ui/widgets/alert_dialog.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';
import 'package:app/ui/widgets/taxonomy_autocomplete.dart';

typedef OnUpdate = void Function(TaxonomySpecies?);

class SpeciesField extends StatefulWidget {
  final TaxonomySpecies? current;
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
  List<Map<String, String?>> get _taxonomySettings {
    final t = AppLocalizations.of(context)!;

    return [
      t.taxonomySpecies,
      t.taxonomyGenus,
      t.taxonomyTribe,
      t.taxonomySubfamily,
      t.taxonomyFamily,
      t.taxonomyOrder,
      t.taxonomyClass,
      t.taxonomyPhylum,
      t.taxonomyKingdom,
    ].indexed.map((item) {
      final index = item.$1;
      final label = item.$2;
      return {
        'label': label,
        'parent': RANKS[index]['parent'],
        'schemaId': RANKS[index]['schemaId']!,
      };
    }).toList(growable: false);
  }

  /// Flag indicating if we're currently editing or not.
  bool _isEditMode = false;

  /// Which ranks are shown to the user.
  int _showUpToRank = 1;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    if (widget.current != null) {
      // Populate current state with full taxonomy when a species was defined
      _requestTaxonomy(0, widget.current!.id);
    }
  }

  void _requestTaxonomy(int fromRank, DocumentId id) async {
    final json = await query(query: getTaxonomy(fromRank, id));
    _populateTaxonomy(fromRank, json);
  }

  void _populateTaxonomy(int fromRank, Map<String, dynamic> json) async {
    // Start with the root of the GraphQL response
    var document = json[DEFAULT_RESULTS_KEY]! as Map<String, dynamic>;

    // Iterate through all ranks and fill in the values into our current state
    // by converting the GraphQL response into autocomplete items.
    for (final (index, rank) in _taxonomySettings.sublist(fromRank).indexed) {
      // Parse and set the current state for this rank
      final parsed = BaseTaxonomy.fromJson(rank['schemaId']!, document);
      _taxonomy[fromRank + index] = AutocompleteItem(
          value: parsed.name, documentId: parsed.id, viewId: parsed.viewId);

      // Prepare data for the following rank
      if (rank['parent'] != null) {
        document =
            document['fields']![rank['parent']!]! as Map<String, dynamic>;
      }
    }
  }

  void _submit() async {
    if (widget.current == null) {
      if (_taxonomy[0] == null || _taxonomy[0]!.value == '') {
        // Nothing has changed, therefore do nothing
        _reset();
        return;
      }
    }

    if (widget.current != null) {
      if (_taxonomy[0] == null || _taxonomy[0]!.value == '') {
        // Species got removed by user
        widget.onUpdate.call(null);
        _reset();
        return;
      }
    }

    // Create all taxons which do not exist yet
    AutocompleteItem? parent;
    for (final (index, item) in _taxonomy.reversed.indexed) {
      final rank = _taxonomySettings[_taxonomy.length - index - 1];
      if (item!.documentId == null) {
        final id = await createTaxon(rank['schemaId']!,
            name: item.value, parentId: parent?.documentId);
        parent =
            AutocompleteItem(value: item.value, documentId: id, viewId: id);
      } else {
        parent = item;
      }
    }

    // Taxon for species (new or existing) got added by user
    widget.onUpdate.call(TaxonomySpecies(BaseTaxonomy(
        SchemaIds.taxonomy_species,
        id: parent!.documentId!,
        viewId: parent.viewId!,
        name: parent.value)));

    _reset();
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
    // Another valid input:
    //
    // * Species: <existing value>
    // * .. followed by many more existing values until end
    //
    // This would be an _invalid_ input:
    //
    // * Species: <new value>
    // * Genus: <existing value>
    // * Tribe: <new value> ! We can't change the tribe of an existing genus !
    bool isInNewRange = _taxonomy[0]!.documentId == null;

    final t = AppLocalizations.of(context)!;
    for (final (index, rank) in _taxonomy.indexed) {
      if (rank == null) {
        // Every rank needs to be defined, either by a new value or an already
        // existing one!
        throw t.editSpeciesErrorNullCase(_taxonomySettings[index]['label']!);
      }

      if (rank.documentId != null) {
        isInNewRange = false;
      }

      if (!isInNewRange && rank.documentId == null) {
        // We do not allow defining new items _after_ existing ones, the parents
        // of existing ranks are unchangeable!
        throw t.editSpeciesErrorInvalidRankCase(
            _taxonomySettings[index]['label']!);
      }
    }
  }

  void _reset() {
    print('RESET');

    setState(() {
      _taxonomy = List.filled(9, null, growable: false);
      _showUpToRank = 1;
      _init();
    });
  }

  void _showErrorAlert(String error) {
    final t = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      builder: (context) {
        return MeliAlertDialog(
            title: t.editSpeciesErrorTitle,
            message: t.editSpeciesErrorMessage(error),
            labelConfirm: t.editSpeciesErrorConfirm);
      },
    );
  }

  void _toggleEditMode() {
    if (_isEditMode) {
      try {
        _validate();
      } catch (error) {
        _showErrorAlert(error.toString());
        return;
      }
    }

    setState(() {
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
          if (value.value == '') {
            _taxonomy[index] = null;
          } else {
            _taxonomy[index] = value;
          }

          if (index == settings.length - 1) {
            return;
          }

          if (value.documentId == null && value.value != '') {
            // Show next editable rank when _new_ taxon was given by user
            setState(() {
              _showUpToRank = max(_showUpToRank, index + 2);
            });
          } else if (value.value == '') {
            // Hide next ranks when field is empty
            if (_showUpToRank - 2 == index) {
              setState(() {
                _showUpToRank = index + 1;
              });
            }
          } else if (value.documentId != null) {
            // Populate taxonomy with parent taxons when user selected existing
            _requestTaxonomy(index, value.documentId!);

            // Hide next ranks
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
    String? displayValue = widget.current == null ? null : widget.current!.name;

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
          onChanged: (AutocompleteItem value) {
            widget.onChanged.call(value);
          }),
    ]);
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/base.dart';
import 'package:app/io/graphql/queries.dart';
import 'package:app/io/p2panda/schemas.dart';
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
  List<AutocompleteItem?> _taxonomy = List.filled(9, null, growable: false);

  /// Flag indicating if we're currently editing the field or not.
  bool _isEditMode = false;

  /// Which ranks are shown to the user.
  int _showUpToRank = 1;

  @override
  void initState() {
    if (widget.current != null) {
      try {
        query(query: getTaxonomy(0, widget.current!.species.id))
            .then((Map<String, dynamic> json) {
          _populateTaxonomy(json);
        });
      } catch (error) {
        print('Taxonomy data could not be parsed: ${error}');
      }
    }

    super.initState();
  }

  void _populateTaxonomy(Map<String, dynamic> json) async {
    var document = json[DEFAULT_RESULTS_KEY]! as Map<String, dynamic>;
    BaseTaxonomy species = BaseTaxonomy.fromJson(
      SchemaIds.taxonomy_species,
      document,
    );

    document = document['fields']!['genus']! as Map<String, dynamic>;
    BaseTaxonomy genus =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_genus, document);

    document = document['fields']!['tribe']! as Map<String, dynamic>;
    BaseTaxonomy tribe =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_tribe, document);

    document = document['fields']!['subfamily']! as Map<String, dynamic>;
    BaseTaxonomy subfamily =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_subfamily, document);

    document = document['fields']!['family']! as Map<String, dynamic>;
    BaseTaxonomy family =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_family, document);

    document = document['fields']!['order']! as Map<String, dynamic>;
    BaseTaxonomy order =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_order, document);

    document = document['fields']!['class']! as Map<String, dynamic>;
    BaseTaxonomy classs =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_class, document);

    document = document['fields']!['phylum']! as Map<String, dynamic>;
    BaseTaxonomy phylum =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_phylum, document);

    document = document['fields']!['kingdom']! as Map<String, dynamic>;
    BaseTaxonomy kingdom =
        BaseTaxonomy.fromJson(SchemaIds.taxonomy_kingdom, document);

    _taxonomy[0] = AutocompleteItem(
        value: species.name, documentId: species.id, viewId: species.viewId);
    _taxonomy[1] = AutocompleteItem(
        value: genus.name, documentId: genus.id, viewId: genus.viewId);
    _taxonomy[2] = AutocompleteItem(
        value: tribe.name, documentId: tribe.id, viewId: tribe.viewId);
    _taxonomy[3] = AutocompleteItem(
        value: subfamily.name,
        documentId: subfamily.id,
        viewId: subfamily.viewId);
    _taxonomy[4] = AutocompleteItem(
        value: family.name, documentId: family.id, viewId: family.viewId);
    _taxonomy[5] = AutocompleteItem(
        value: order.name, documentId: order.id, viewId: order.viewId);
    _taxonomy[6] = AutocompleteItem(
        value: classs.name, documentId: classs.id, viewId: classs.viewId);
    _taxonomy[7] = AutocompleteItem(
        value: phylum.name, documentId: phylum.id, viewId: phylum.viewId);
    _taxonomy[8] = AutocompleteItem(
        value: kingdom.name, documentId: kingdom.id, viewId: kingdom.viewId);
  }

  void _submit() async {
    // @TODO
    print('submit');
    widget.onUpdate.call(_taxonomy);
  }

  bool _validate() {
    if (_taxonomy[0] == null) {
      // Nothing was changed, all good
      return true;
    }

    if (_taxonomy[0] != null && _taxonomy[0]!.value == '') {
      // Species field is empty which indicates that user wants to remove it
      return true;
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
        return false;
      }

      if (rank.documentId != null) {
        isInNewRange = false;
      }

      if (!isInNewRange && rank.documentId == null) {
        // We do not allow defining new items _after_ existing ones, the parents
        // of existing ranks are unchangeable!
        return false;
      }
    }

    return true;
  }

  void _toggleEditMode() {
    setState(() {
      if (!_validate()) {
        // @TODO
        print('Invalid');
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
    final t = AppLocalizations.of(context)!;

    final settings = [
      {'label': t.taxonomySpecies, 'schemaId': SchemaIds.taxonomy_species},
      {'label': t.taxonomyGenus, 'schemaId': SchemaIds.taxonomy_genus},
      {'label': t.taxonomyTribe, 'schemaId': SchemaIds.taxonomy_tribe},
      {'label': t.taxonomySubfamily, 'schemaId': SchemaIds.taxonomy_subfamily},
      {'label': t.taxonomyFamily, 'schemaId': SchemaIds.taxonomy_family},
      {'label': t.taxonomyOrder, 'schemaId': SchemaIds.taxonomy_order},
      {'label': t.taxonomyClass, 'schemaId': SchemaIds.taxonomy_class},
      {'label': t.taxonomyPhylum, 'schemaId': SchemaIds.taxonomy_phylum},
      {'label': t.taxonomyKingdom, 'schemaId': SchemaIds.taxonomy_kingdom},
    ];

    final Iterable<Widget> ranks = settings.indexed.map((item) {
      final index = item.$1;
      final rank = item.$2;

      return Rank(
        rank['label']!,
        rank['schemaId']!,
        _taxonomy[index],
        onChanged: (AutocompleteItem value) {
          _taxonomy[index] = value;

          if (index == settings.length - 1) {
            return;
          }

          if (value.documentId == null && value.value != '') {
            setState(() {
              _showUpToRank = index + 2;
            });
          } else {
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

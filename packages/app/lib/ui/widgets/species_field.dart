// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/schemas.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/species.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';
import 'package:app/ui/widgets/taxonomy_autocomplete.dart';

typedef OnUpdate = void Function(AutocompleteItem?);

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

  void _submit() async {
    // @TODO
  }

  void _toggleEditMode() {
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

          if (value.documentId == null) {
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

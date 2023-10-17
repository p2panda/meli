// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/species.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';

typedef OnUpdate = void Function(AutocompleteItem?);

class SpeciesField extends StatefulWidget {
  final Species? current;
  final OnUpdate onUpdate;

  SpeciesField(this.current, {super.key, required this.onUpdate});

  @override
  State<SpeciesField> createState() => _SpeciesFieldState();
}

class _SpeciesFieldState extends State<SpeciesField> {
  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  void _submit() async {
    // @TODO
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;

      // If we flip from edit mode to read-only mode we interpret this as a
      // "submit" action by the user
      if (!isEditMode) {
        _submit();
      }
    });
  }

  Widget _editableValue() {
    return Text('@TODO');
  }

  @override
  Widget build(BuildContext context) {
    String? displayValue =
        widget.current == null ? null : widget.current!.species.name;

    return EditableCard(
        title: AppLocalizations.of(context)!.speciesCardTitle,
        isEditMode: isEditMode,
        child: isEditMode ? _editableValue() : ReadOnlyValue(displayValue),
        onChanged: _toggleEditMode);
  }
}

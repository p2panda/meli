// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/local_names.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/local_name_autocomplete.dart';
import 'package:app/ui/widgets/read_only_value.dart';

typedef OnUpdate = void Function(AutocompleteItem?);

class LocalNameField extends StatefulWidget {
  final LocalName? current;
  final OnUpdate onUpdate;

  LocalNameField(this.current, {super.key, required this.onUpdate});

  @override
  State<LocalNameField> createState() => _LocalNameFieldState();
}

class _LocalNameFieldState extends State<LocalNameField> {
  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Contains changed value when user adjusted the field.
  AutocompleteItem? _dirty;

  void _submit() async {
    if (_dirty == null) {
      // Nothing has changed
      return;
    }

    if (_dirty!.value == '') {
      // Value is empty, we consider the user wants to remove it
      widget.onUpdate.call(null);
    } else {
      // Value gets updated (either with item from database or something new)
      widget.onUpdate.call(_dirty!);
    }
  }

  void _changeValue(AutocompleteItem newValue) async {
    if (widget.current == null) {
      // User selected an item when none was selected before
      _dirty = newValue;
    } else if (widget.current!.name != newValue.value) {
      // User selected a different item than before
      _dirty = newValue;
    } else {
      // User selected the same item or still no item as before .. do nothing!
    }
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
    // Convert existing LocalName for autocomplete widget. This will then also
    // contain the id and view id of that document
    AutocompleteItem? initialValue = widget.current != null
        ? AutocompleteItem(
            value: widget.current!.name, // Display value
            documentId: widget.current!.id,
            viewId: widget.current!.viewId)
        : null;

    return LocalNameAutocomplete(
        initialValue: initialValue,
        // Make sure that we focus the text field and show the keyboard as soon
        // as we've entered "edit mode"
        autofocus: true,
        // Flip "edit mode" to false as soon as user hit the "submit" button on
        // the keyboard
        onSubmit: _toggleEditMode,
        onChanged: _changeValue);
  }

  @override
  Widget build(BuildContext context) {
    String? displayValue = widget.current == null ? null : widget.current!.name;

    return EditableCard(
        title: AppLocalizations.of(context)!.localNameCardTitle,
        isEditMode: isEditMode,
        child: isEditMode ? _editableValue() : ReadOnlyValue(displayValue),
        onChanged: _toggleEditMode);
  }
}

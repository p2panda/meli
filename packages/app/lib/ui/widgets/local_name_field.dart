// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/local_names.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/local_name_autocomplete.dart';
import 'package:app/ui/widgets/read_only_value.dart';
import 'package:app/ui/widgets/action_buttons.dart';

typedef OnUpdate = Future<void> Function(AutocompleteItem?);

class LocalNameField extends StatefulWidget {
  final LocalName? current;
  final OnUpdate onUpdate;

  const LocalNameField(this.current, {super.key, required this.onUpdate});

  @override
  State<LocalNameField> createState() => _LocalNameFieldState();
}

class _LocalNameFieldState extends State<LocalNameField> {
  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Contains changed value when user adjusted the field.
  AutocompleteItem? _dirty;

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _cancel() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _onChanged(AutocompleteItem newValue) {
    _dirty = newValue;
  }

  void _onSubmit() {
    if (_dirty == null) {
      // Nothing has changed
    } else if (_dirty!.value == '') {
      // Value is empty, we consider the user wants to remove it
      widget.onUpdate.call(null);
    } else {
      // Value gets updated (either with item from database or something new)
      widget.onUpdate.call(_dirty!);
    }

    // Any time the submit method is triggered we toggle out of edit mode
    _toggleEditMode();
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
        initialValue: initialValue, onSubmit: _onSubmit, onChanged: _onChanged);
  }

  @override
  Widget build(BuildContext context) {
    String? displayValue = widget.current?.name;

    return EditableCard(
        title: AppLocalizations.of(context)!.localNameCardTitle,
        isEditMode: isEditMode,
        onChanged: _toggleEditMode,
        child: Column(
            children: isEditMode
                ? [
                    _editableValue(),
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ActionButtons(
                          onAction: _onSubmit,
                          onCancel: _cancel,
                        ))
                  ]
                : [ReadOnlyValue(displayValue)]));
  }
}

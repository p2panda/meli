// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';

typedef OnUpdate = void Function(String?);

enum InputMode { read, edit }

class NoteField extends StatefulWidget {
  final String? value;
  final OnUpdate onUpdate;

  const NoteField(this.value, {super.key, required this.onUpdate});

  @override
  State<NoteField> createState() => _NoteFieldState();
}

class _NoteFieldState extends State<NoteField> {
  InputMode _inputMode = InputMode.read;
  late TextEditingController _textInputController;
  late FocusNode _textInputFocusNode;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textInputController = TextEditingController(text: widget.value ?? "");
    _textInputFocusNode =
        FocusNode(canRequestFocus: _inputMode == InputMode.edit);
  }

  @override
  void didUpdateWidget(prev) {
    super.didUpdateWidget(prev);
    // Needed in order "reset" the initialValue of the input based on the change received by widget.value
    _textInputController.text = widget.value ?? "";
  }

  @override
  void dispose() {
    _textInputController.dispose();
    _textInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final initialValue = widget.value ?? '';

    return Form(
        key: _formKey,
        child: MeliCard(
            child: Column(children: [
          MeliCardHeader(
              title: t.noteCardTitle,
              icon: _inputMode == InputMode.read
                  ? CardActionButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _handleStartEditMode,
                    )
                  : null),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TODO: TextField seems to have a bug where it does not respect _textInputFocusNode.canRequestFocus being false when in 'read' input mode
                  TextFormField(
                      controller: _textInputController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      focusNode: _textInputFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 5,
                      onSaved: (text) => _handleSubmit(text, initialValue),
                      readOnly: _inputMode == InputMode.read,
                      textCapitalization: TextCapitalization.sentences),
                  if (_inputMode == InputMode.edit) ...[
                    const SizedBox(height: 12),
                    Row(children: [
                      OverflowBar(
                        spacing: 12,
                        overflowAlignment: OverflowBarAlignment.start,
                        children: [
                          FilledButton(
                              onPressed: _handleSave,
                              child: Text(t.noteCardSaveAction)),
                          OutlinedButton(
                              onPressed: _handleCancel,
                              child: Text(t.noteCardCancelAction))
                        ],
                      )
                    ])
                  ]
                ],
              )),
        ])));
  }

  void _handleCancel() {
    setState(() {
      _formKey.currentState!.reset();
      _inputMode = InputMode.read;
      _textInputFocusNode.canRequestFocus = false;
    });
  }

  void _handleSubmit(String? text, String initialValue) {
    final trimmed = (text ?? '').trim();

    if (initialValue == trimmed) {
      _handleCancel();
      return;
    }

    setState(() {
      _inputMode = InputMode.read;
      _textInputFocusNode.canRequestFocus = false;
      widget.onUpdate.call(trimmed);
    });
  }

  void _handleSave() {
    _formKey.currentState!.save();
  }

  void _handleStartEditMode() {
    setState(() {
      _inputMode = InputMode.edit;
      _textInputFocusNode.canRequestFocus = true;
      _textInputFocusNode.requestFocus();
    });
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';

typedef OnUpdate = void Function(String);

class EditableTextField extends StatefulWidget {
  final String title;
  final String current;
  final OnUpdate onUpdate;

  const EditableTextField(this.current,
      {super.key, required this.title, required this.onUpdate});

  @override
  State<EditableTextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<EditableTextField> {
  final TextEditingController _controller = TextEditingController();

  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Contains changed value when user adjusted the field.
  String _dirty = "";

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditableTextField oldWidget) {
    _init();
    super.didUpdateWidget(oldWidget);
  }

  void _init() {
    _controller.text = widget.current;
  }

  void _submit() async {
    if (_dirty == widget.current) {
      return; // Nothing has changed
    } else {
      widget.onUpdate.call(_dirty);
    }
  }

  void _changeValue(String newValue) async {
    setState(() {
      _dirty = newValue;
    });
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      if (!isEditMode) {
        _submit();
      }
    });
  }

  Widget _editableValue() {
    return TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      controller: _controller,
      maxLines: 5,
      onChanged: _changeValue,
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 2.0, style: BorderStyle.solid)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 2.0, style: BorderStyle.solid)),
      ),
    );
  }

  Widget _readOnlyValue() {
    if (widget.current == '') {
      return const ReadOnlyValue(null);
    } else {
      return SizedBox(
          width: double.infinity,
          child: Text(widget.current, textAlign: TextAlign.start));
    }
  }

  @override
  Widget build(BuildContext context) {
    return EditableCard(
        title: widget.title,
        isEditMode: isEditMode,
        onChanged: _toggleEditMode,
        child: isEditMode ? _editableValue() : _readOnlyValue());
  }
}

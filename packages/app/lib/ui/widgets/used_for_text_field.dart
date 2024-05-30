// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/save_cancel_buttons.dart';
import 'package:flutter/material.dart';

class UsedForTextField extends StatefulWidget {
  final void Function(String) submit;
  final void Function() cancel;

  const UsedForTextField(
      {super.key, required this.submit, required this.cancel});

  @override
  State<UsedForTextField> createState() => _UsedForTextFieldState();
}

class _UsedForTextFieldState extends State<UsedForTextField> {
  final TextEditingController _controller = TextEditingController();
  bool disabled = true;

  void _handleSubmit() {
    if (disabled) {
      return;
    }

    if (_controller.text == '') {
      return;
    }

    widget.submit(_controller.text);

    _controller.text = '';
    setState(() {
      disabled = true;
    });
  }

  void _handleCancel() {
    widget.cancel();
  }

  void _onChange(String newText) {
    if (newText != '') {
      setState(() {
        disabled = false;
      });
    } else {
      setState(() {
        disabled = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            controller: _controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.text,
            maxLines: 1,
            minLines: 1,
            onChanged: _onChange,
            textCapitalization: TextCapitalization.sentences),
        const SizedBox(height: 12),
        SaveCancel(
          handleSave: _handleSubmit,
          handleCancel: _handleCancel,
        )
      ],
    );
  }
}

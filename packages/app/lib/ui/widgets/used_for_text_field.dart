// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/action_buttons.dart';

class UsedForTextField extends StatefulWidget {
  final void Function(String) onSubmit;
  final void Function() onCancel;

  const UsedForTextField(
      {super.key, required this.onSubmit, required this.onCancel});

  @override
  State<UsedForTextField> createState() => _UsedForTextFieldState();
}

class _UsedForTextFieldState extends State<UsedForTextField> {
  final TextEditingController _controller = TextEditingController();
  bool disabled = true;

  void _handleSubmit() {
    if (_controller.text == '') {
      return;
    }

    widget.onSubmit(_controller.text);
    _controller.text = '';

    setState(() {
      disabled = true;
    });
  }

  void _handleCancel() {
    widget.onCancel();
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
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
            controller: _controller,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MeliColors.plum,
                      width: 3,
                      style: BorderStyle.solid)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: MeliColors.plum,
                      width: 3,
                      style: BorderStyle.solid)),
            ),
            keyboardType: TextInputType.text,
            scrollPadding: const EdgeInsets.only(bottom: 100.0),
            onChanged: _onChange,
            textCapitalization: TextCapitalization.sentences),
        const SizedBox(height: 10),
        ActionButtons(
          actionLabel: t.usedForCreateButton,
          onAction: disabled ? null : _handleSubmit,
          onCancel: _handleCancel,
        )
      ],
    );
  }
}

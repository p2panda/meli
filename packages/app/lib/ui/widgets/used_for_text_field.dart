// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsedForTextField extends StatefulWidget {
  final void Function(String) submit;

  const UsedForTextField({super.key, required this.submit});

  @override
  State<UsedForTextField> createState() => _UsedForTextFieldState();
}

class _UsedForTextFieldState extends State<UsedForTextField> {
  final TextEditingController _controller = TextEditingController();
  bool disabled = true;

  _onSubmit() {
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
            decoration: const InputDecoration(border: OutlineInputBorder()),
            keyboardType: TextInputType.text,
            maxLines: 1,
            minLines: 1,
            onChanged: _onChange,
            textCapitalization: TextCapitalization.sentences),
        const SizedBox(height: 12),
        Row(children: [
          OverflowBar(
            spacing: 12,
            overflowAlignment: OverflowBarAlignment.start,
            children: [
              FilledButton(
                  style: disabled
                      ? const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey))
                      : const ButtonStyle(),
                  onPressed: _onSubmit,
                  child: Text(t.usedForCreateTag)),
            ],
          )
        ])
      ],
    );
  }
}

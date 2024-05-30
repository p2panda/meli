// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';

class EditableCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onChanged;
  final bool isEditMode;

  const EditableCard(
      {super.key,
      this.isEditMode = false,
      required this.title,
      required this.child,
      required this.onChanged});

  Widget _icon() {
    final icon =
        isEditMode ? const Icon(Icons.lock_open) : const Icon(Icons.lock_outline);
    return CardActionButton(icon: icon);
  }

  Widget _content() {
    return Column(
      children: [
        MeliCardHeader(
            title: title,
            icon: _icon(),
            onPress: () {
              onChanged.call();
            }),
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            child: child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(child: _content());
  }
}

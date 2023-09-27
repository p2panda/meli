// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';

class EditableCard extends StatefulWidget {
  final String title;
  final Widget child;

  const EditableCard({super.key, required this.title, required this.child});

  @override
  State<EditableCard> createState() => _EditableCardState();
}

class _EditableCardState extends State<EditableCard> {
  bool isEditMode = false;

  Widget _icon() {
    final icon =
        this.isEditMode ? Icon(Icons.check) : Icon(Icons.edit_outlined);
    return CardActionButton(
        icon: icon,
        onPressed: () {
          setState(() {
            this.isEditMode = !this.isEditMode;
          });
        });
  }

  Widget _content() {
    return Column(
      children: [
        MeliCardHeader(title: widget.title, icon: this._icon()),
        widget.child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(child: this._content());
  }
}

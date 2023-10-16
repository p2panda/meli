// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';

class EditableCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onChanged;
  final bool isDirty;
  final bool isEditMode;

  const EditableCard(
      {super.key,
      this.isDirty = false,
      this.isEditMode = false,
      required this.title,
      required this.child,
      required this.onChanged});

  Widget _icon() {
    final icon = isEditMode ? Icon(Icons.check) : Icon(Icons.edit_outlined);
    return CardActionButton(
        icon: icon,
        onPressed: () {
          onChanged.call();
        });
  }

  Widget _content(Color color) {
    return Column(
      children: [
        MeliCardHeader(color: color, title: title, icon: _icon()),
        Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            child: child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = isDirty ? MeliColors.electric : MeliColors.pink;
    return MeliCard(
        color: color, borderColor: color, child: this._content(color));
  }
}

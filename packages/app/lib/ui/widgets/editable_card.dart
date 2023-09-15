// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EditableCard extends StatefulWidget {
  final Map<String, String> fields;
  final String? title;

  EditableCard({super.key, this.title, required this.fields});

  @override
  State<EditableCard> createState() => _EditableCardState();
}

class _EditableCardState extends State<EditableCard> {
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      icon: GestureDetector(
        child: Icon(Icons.edit),
        onTap: () => setState(() {
          this.editMode = !this.editMode;
        }),
      ),
      title: this.widget.title,
      child: Column(
        children: <Widget>[
          ...this.widget.fields.entries.map((entry) => FormBuilderTextField(
                enabled: this.editMode,
                name: entry.key,
                initialValue: entry.value,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ))
        ],
      ),
    );
  }
}

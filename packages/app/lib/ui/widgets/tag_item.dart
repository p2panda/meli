// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class TagItem extends StatelessWidget {
  final String label;
  final void Function(String) onClick;

  const TagItem({super.key, required this.label, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          onClick(label);
        },
        child: Material(
          elevation: 3,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}

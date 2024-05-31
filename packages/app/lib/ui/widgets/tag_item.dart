// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class TagItem extends StatelessWidget {
  final String label;
  final void Function(String)? onClick;
  final bool showDeleteIcon;

  const TagItem(
      {super.key,
      required this.label,
      this.onClick,
      this.showDeleteIcon = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: GestureDetector(
        onTap: (onClick != null)
            ? () {
                onClick!(label);
              }
            : null,
        child: Material(
          elevation: 3,
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                if (showDeleteIcon)
                  const Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 1),
                    child: Icon(size: 20, color: MeliColors.plum, Icons.delete),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

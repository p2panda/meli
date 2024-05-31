// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/utils/sleep.dart';

const DELETE_ANIMATION_MS = 250;

class TagItem extends StatefulWidget {
  final void Function(String)? onClick;
  final String label;
  final bool isDeleteMode;

  const TagItem(
      {super.key,
      required this.label,
      this.onClick,
      this.isDeleteMode = false});

  @override
  State<TagItem> createState() => _TagItemState();
}

class _TagItemState extends State<TagItem> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: DELETE_ANIMATION_MS),
        opacity: _visible ? 1.0 : 0.0,
        child: GestureDetector(
          child: Material(
            elevation: 2,
            color: MeliColors.white,
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            child: InkWell(
              onTap: (widget.onClick != null)
                  ? () async {
                      if (widget.isDeleteMode) {
                        setState(() {
                          _visible = false;
                        });
                      }

                      await sleep(DELETE_ANIMATION_MS);
                      widget.onClick!(widget.label);
                    }
                  : null,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(widget.label,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    if (widget.isDeleteMode)
                      const Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 1),
                        child: Icon(
                            size: 20, color: MeliColors.plum, Icons.delete),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

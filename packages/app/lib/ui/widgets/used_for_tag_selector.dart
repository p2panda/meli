import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/tag_item.dart';
import 'package:flutter/material.dart';

import 'infinite_dedup_tags_list.dart';

class UsedForTagSelector extends StatefulWidget {
  final void Function(String) onTagClick;
  final Paginator<UsedFor> paginator;

  const UsedForTagSelector(
      {super.key, required this.paginator, required this.onTagClick});

  @override
  State<UsedForTagSelector> createState() => _UsedForTagSelectorState();
}

class _UsedForTagSelectorState extends State<UsedForTagSelector> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: MeliColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(13.0)),
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: InfiniteDedupTagsList(
            paginator: widget.paginator,
            itemsBuilder: (List<UsedFor> uses) {
              return uses
                  .map((use) =>
                      TagItem(label: use.usedFor, onClick: widget.onTagClick))
                  .toList();
            }),
      ),
    );
  }
}

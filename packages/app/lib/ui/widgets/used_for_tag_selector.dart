// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/used_for_dedup_tag_list.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/tag_item.dart';

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
    return DeduplicatedUsedForTagsList(
        builder: (UsedFor usedFor) {
          return Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child:
                  TagItem(label: usedFor.usedFor, onClick: widget.onTagClick));
        },
        paginator: widget.paginator);
  }
}

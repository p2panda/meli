// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/ui/widgets/tag_item.dart';

class UsedForList extends StatefulWidget {
  final Paginator<UsedFor> paginator;
  final void Function(UsedFor usedFor) onDeleteClick;
  final bool isEditMode;

  const UsedForList(
      {super.key,
      required this.paginator,
      required this.onDeleteClick,
      this.isEditMode = false});

  @override
  State<UsedForList> createState() => _UsedForListState();
}

class _UsedForListState extends State<UsedForList> {
  Widget _item(UsedFor document) {
    return TagItem(
        label: document.usedFor,
        showDeleteIcon: widget.isEditMode,
        onClick: (String label) {
          widget.onDeleteClick(document);
        });
  }

  @override
  Widget build(BuildContext context) {
    return PaginationBase<UsedFor>(
        builder: (List<UsedFor> collection) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ...collection.map((document) => _item(document)),
            ],
          );
        },
        paginator: widget.paginator);
  }
}

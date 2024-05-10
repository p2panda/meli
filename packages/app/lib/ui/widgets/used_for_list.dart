// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/pagination_list.dart';
import 'package:flutter/material.dart';

import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';

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
  Widget _item(UsedFor usedFor) {
    return Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 6,
                  child: Text(usedFor.usedFor,
                      style: Theme.of(context).textTheme.titleMedium)),
              Expanded(
                flex: 1,
                child: widget.isEditMode
                    ? Container(
                        constraints: const BoxConstraints(maxHeight: 23),
                        child: IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              widget.onDeleteClick(usedFor);
                            },
                            icon: const Icon(size: 20, Icons.delete)),
                      )
                    : const SizedBox(),
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginationList<UsedFor>(
        builder: (UsedFor usedFor) {
          return Container(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: _item(usedFor));
        },
        paginator: widget.paginator);
  }
}

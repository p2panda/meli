import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/infinite_scroll_list.dart';
import 'package:app/ui/widgets/tag_item.dart';
import 'package:flutter/material.dart';

class UsedForList extends StatefulWidget {
  final Paginator<UsedFor> paginator;
  final void Function(UsedFor usedFor) onDeleteClick;
  bool isEditMode = false;

  UsedForList(
      {super.key,
      required this.paginator,
      required this.onDeleteClick,
      this.isEditMode = false});

  @override
  State<UsedForList> createState() => _UsedForListState();
}

class _UsedForListState extends State<UsedForList> {
  List<Widget> _usesListBuilder(List<UsedFor> uses) {
    return [
      ...uses.map((usedFor) => Container(
          constraints: const BoxConstraints(minHeight: 30),
          padding: const EdgeInsets.symmetric(vertical: 7.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 6,
                    child: Text(usedFor.usedFor,
                        style: const TextStyle(fontSize: 16))),
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
              ]))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MeliColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(13.0)),
      ),
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(
          maxHeight: 120,
        ),
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        child: RawScrollbar(
          thumbVisibility: true,
          thumbColor: Colors.grey,
          radius: const Radius.circular(16),
          thickness: 4,
          child: InfiniteScrollList(
              emptyMessage: "No uses selected yet.",
              paginator: widget.paginator,
              builder: _usesListBuilder),
        ),
      ),
    );
  }
}

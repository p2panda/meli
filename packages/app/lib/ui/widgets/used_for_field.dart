// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/infinite_scroll_list.dart';
import 'package:app/ui/widgets/infinite_dedup_tags_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/loading_overlay.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/io/graphql/graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef OnUpdate = Future<DocumentViewId> Function(String);

class UsedForField extends StatefulWidget {
  final DocumentId sighting;

  const UsedForField({super.key, required this.sighting});

  @override
  State<UsedForField> createState() => _UsedForFieldState();
}

class _UsedForFieldState extends State<UsedForField> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<LoadingOverlayState> _overlayKey = GlobalKey();
  late Paginator<UsedFor> listPaginator =
      UsedForPaginator(sighting: widget.sighting);
  late Paginator<UsedFor> tagPaginator = UsedForPaginator();

  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Contains changed value when user adjusted the field.
  String? _dirty;

  Future<void> _createUse(String usedForString) async {
    // Show the overlay spinner
    _overlayKey.currentState!.show();

    // Create a new UsedFor document which relates to the current sighting.
    DocumentViewId usedforViewId =
        await createUsedFor(sighting: widget.sighting, usedFor: usedForString);

    // We want to wait until it is materialized and then refresh the
    // paginated query
    bool isReady = false;
    while (!isReady) {
      final options = QueryOptions(document: gql(usedForQuery(usedforViewId)));
      final result = await client.query(options);
      isReady = (result.data?['document'] != null);
      sleep(const Duration(milliseconds: 100));
    }

    // Refresh both paginators
    listPaginator.refresh!();
    tagPaginator.refresh!();

    // Hide the overlay
    _overlayKey.currentState!.hide();
  }

  void _deleteUse(UsedFor usedFor) async {
    // Show the overlay spinner
    _overlayKey.currentState!.show();

    // Delete the used for document.
    await deleteUsedFor(usedFor.viewId);

    // We want to wait until the delete is materialized and then refresh the
    // paginated query
    bool isDeleted = false;
    while (!isDeleted) {
      final options = QueryOptions(document: gql(usedForQuery(usedFor.id)));
      final result = await client.query(options);
      isDeleted = (result.data?['document'] == null);
      sleep(const Duration(milliseconds: 150));
    }

    // Refresh only the list paginator
    listPaginator.refresh!();

    // Hide the overlay
    _overlayKey.currentState!.hide();
  }

  void _submit() async {
    if (_dirty == null) {
      // Nothing has changed
      return;
    }

    if (_dirty == '') {
      // We consider that the user changed their mind and actually doesn't
      // want to create a UsedFor.
      _dirty = null;
      return;
    }

    await _createUse(_dirty!);

    _controller.text = '';
    setState(() {
      _dirty = null;
    });
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;

      // If we flip from edit mode to read-only mode we interpret this as a
      // "submit" action by the user
      if (!isEditMode) {
        _submit();
      }

      _controller.text = '';
      setState(() {
        _dirty = null;
      });
    });
  }

  void _changeNewTagValue(String newValue) {
    setState(() {
      _dirty = newValue;
    });
  }

  void _onTagClick(UsedFor usedFor) async {
    await _createUse(usedFor.usedFor);
  }

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
                  child: isEditMode
                      ? Container(
                          constraints: const BoxConstraints(maxHeight: 23),
                          child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                _deleteUse(usedFor);
                              },
                              icon: const Icon(size: 20, Icons.delete)),
                        )
                      : const SizedBox(),
                )
              ]))),
    ];
  }

  Widget _usesList() {
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
        child: InfiniteScrollList(
            paginator: listPaginator, builder: _usesListBuilder),
      ),
    );
  }

  Widget _tagList() {
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
            paginator: tagPaginator,
            itemsBuilder: (List<UsedFor> uses) {
              return uses
                  .map((usedFor) => UsedForTagItem(
                      usedFor: usedFor, createUsedFor: _onTagClick))
                  .toList();
            }),
      ),
    );
  }

  Widget _newTagField() {
    return TextField(
      keyboardType: TextInputType.text,
      minLines: 1,
      controller: _controller,
      maxLines: 1,
      onChanged: _changeNewTagValue,
      onEditingComplete: _submit,
      decoration: const InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 2.0, style: BorderStyle.solid)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Colors.black, width: 2.0, style: BorderStyle.solid)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditableCard(
        title: AppLocalizations.of(context)!.usedForCardTitle,
        isEditMode: isEditMode,
        onChanged: _toggleEditMode,
        child: Container(
          constraints: BoxConstraints(maxHeight: isEditMode ? 400 : 120),
          child: LoadingOverlay(
            key: _overlayKey,
            child: Column(
              children: [
                SizedBox(height: 120, child: _usesList()),
                ...(isEditMode
                    ? [
                        const SizedBox(height: 10),
                        Expanded(child: _tagList()),
                        const SizedBox(height: 10),
                        _newTagField()
                      ]
                    : [const SizedBox()])
              ],
            ),
          ),
        ));
  }
}

class UsedForTagItem extends StatelessWidget {
  final UsedFor usedFor;
  final void Function(UsedFor) createUsedFor;

  const UsedForTagItem(
      {super.key, required this.usedFor, required this.createUsedFor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          createUsedFor(usedFor);
        },
        child: Material(
          elevation: 5,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container(
            margin: const EdgeInsets.all(5),
            child: Text(usedFor.usedFor),
          ),
        ),
      ),
    );
  }
}

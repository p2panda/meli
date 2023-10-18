// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/loading_overlay.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/used_for_autocomplete.dart';
import 'package:app/io/graphql/graphql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

typedef OnUpdate = Future<DocumentViewId?> Function(AutocompleteItem?);

class UsedForField extends StatefulWidget {
  final UsedFor? current;
  final DocumentId sighting;
  final OnUpdate onUpdate;

  UsedForField(this.current,
      {super.key, required this.sighting, required this.onUpdate});

  @override
  State<UsedForField> createState() => _UsedForFieldState();
}

class _UsedForFieldState extends State<UsedForField> {
  late Paginator<UsedFor> paginator =
      UsedForPaginator(sighting: this.widget.sighting);
  late Paginator<UsedFor> usedForTagPaginator = UsedForPaginator();
  final GlobalKey<LoadingOverlayState> _overlayKey = GlobalKey();

  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Contains changed value when user adjusted the field.
  AutocompleteItem? _dirty;

  void _delete(UsedFor usedFor) async {
    // Show the overlay spinner
    _overlayKey.currentState!.show();

    await deleteUsedFor(usedFor.viewId);

    // We want to wait until the delete is materialized and then refresh the
    // paginated query
    bool isDeleted = false;
    while (!isDeleted) {
      final options = QueryOptions(document: gql(usedForQuery(usedFor.id)));
      final result = await client.query(options);
      print(result.data);
      isDeleted = (result.data?['document'] == null);
      sleep(Duration(milliseconds: 150));
    }

    // Refresh the paginator
    this.paginator.refresh!();

    // Hide the overlay
    _overlayKey.currentState!.hide();
  }

  void _submit() async {
    if (_dirty == null) {
      // Nothing has changed
      return;
    }

    if (_dirty!.value == '') {
      // We consider that the user changed their mind and actually doesn't
      // want to create a UsedFor.
      _dirty = null;
      return;
    }

    // Show the overlay spinner
    _overlayKey.currentState!.show();

    // Create the new UsedFor document
    DocumentViewId? newUsedFor = await widget.onUpdate.call(_dirty!);

    // We want to wait until it is materialized and then refresh the
    // paginated query
    bool isReady = false;
    while (!isReady) {
      final options = QueryOptions(document: gql(usedForQuery(newUsedFor!)));
      final result = await client.query(options);
      isReady = (result.data?['document'] != null);
      sleep(Duration(milliseconds: 100));
    }

    // Refresh the paginator
    this.paginator.refresh!();

    // Hide the overlay
    _overlayKey.currentState!.hide();
  }

  void _changeValue(AutocompleteItem newValue) async {
    if (widget.current == null) {
      // User selected an item when none was selected before
      _dirty = newValue;
    } else if (widget.current!.usedFor != newValue.value) {
      // User selected a different item than before
      _dirty = newValue;
    } else {
      // User selected the same item or still no item as before .. do nothing!
    }
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;

      // If we flip from edit mode to read-only mode we interpret this as a
      // "submit" action by the user
      if (!isEditMode) {
        _submit();
      }
    });
  }

  Widget _editableValue() {
    return UsedForAutocomplete(
        // Initial value is always null.
        initialValue: null,
        // Don't show keyboard or focus on text field when edit mode clicked
        autofocus: false,
        // Flip "edit mode" to false as soon as user hit the "submit" button on
        // the keyboard
        onSubmit: _toggleEditMode,
        onChanged: _changeValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: LoadingOverlay(
        key: _overlayKey,
        child: EditableCard(
            title: AppLocalizations.of(context)!.usedForCardTitle,
            isEditMode: isEditMode,
            child: Container(
              height: 250,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: UsedForList(
                        paginator: this.paginator, onDelete: this._delete),
                  ),
                  Expanded(
                    flex: 2,
                    child: UsedForTags(paginator: this.usedForTagPaginator),
                  ),
                  isEditMode ? _editableValue() : SizedBox(),
                ],
              ),
            ),
            onChanged: _toggleEditMode),
      ),
    );
  }
}

class UsedForList extends StatefulWidget {
  final void Function(UsedFor usedFor) onDelete;
  final Paginator<UsedFor> paginator;
  final bool isEditMode;

  UsedForList(
      {super.key,
      this.isEditMode = false,
      required this.paginator,
      required this.onDelete});

  @override
  State<UsedForList> createState() => _UsedForListState();
}

class _UsedForListState extends State<UsedForList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    this._initScrollController();
  }

  void _initScrollController() {
    scrollController.addListener(() {
      final _scrollOffset = scrollController.offset;
      final _maxOffset = scrollController.position.maxScrollExtent;
      if (_scrollOffset >= _maxOffset) {
        if (this.widget.paginator.fetchMore != null) {
          this.widget.paginator.fetchMore!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: PaginationList<UsedFor>(
          listBuilder: (List<UsedFor> uses, Widget? loadMoreWidget) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...uses.map((usedFor) => Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: SizedBox(
                        height: 30,
                        child: Row(children: [
                          Expanded(child: Text(usedFor.usedFor)),
                          this.widget.isEditMode
                              ? IconButton(
                                  onPressed: () {
                                    this.widget.onDelete(usedFor);
                                  },
                                  icon: Icon(Icons.delete))
                              : SizedBox()
                        ]),
                      ))),
                  (loadMoreWidget != null) ? loadMoreWidget : SizedBox()
                ]);
          },
          loadMoreBuilder: (BuildContext context, VoidCallback onLoadMore) {
            return Text("...");
          },
          paginator: this.widget.paginator),
    );
  }
}

class UsedForTags extends StatefulWidget {
  final Paginator<UsedFor> paginator;
  final bool isEditMode;

  UsedForTags({super.key, this.isEditMode = false, required this.paginator});

  @override
  State<UsedForTags> createState() => _UsedForTagsState();
}

class _UsedForTagsState extends State<UsedForTags> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    this._initScrollController();
  }

  void _initScrollController() {
    scrollController.addListener(() {
      final _scrollOffset = scrollController.offset;
      final _maxOffset = scrollController.position.maxScrollExtent;
      if (_scrollOffset >= _maxOffset) {
        if (this.widget.paginator.fetchMore != null) {
          this.widget.paginator.fetchMore!();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaginationList<UsedFor>(
        listBuilder: (List<UsedFor> uses, Widget? loadMoreWidget) {
          return SingleChildScrollView(
              controller: scrollController,
              child: Wrap(children: [
                ...uses.map((usedFor) => Container(
                      padding: EdgeInsets.all(5),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          child: Text(usedFor.usedFor),
                          margin: EdgeInsets.all(5),
                        ),
                      ),
                    )),
                (loadMoreWidget != null) ? loadMoreWidget : SizedBox()
              ]));
        },
        loadMoreBuilder: (BuildContext context, VoidCallback onLoadMore) {
          return Container(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
              onTap: onLoadMore,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  child: Text("more..."),
                  margin: EdgeInsets.all(5),
                ),
              ),
            ),
          );
        },
        paginator: this.widget.paginator);
  }
}

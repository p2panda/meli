// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:app/ui/widgets/pagination_used_for_list.dart';
import 'package:app/ui/widgets/pagination_used_for_tags_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/loading_overlay.dart';
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
    this.usedForTagPaginator.refresh!();

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

  void _createUsedFor(UsedFor usedFor) async {
    // Show the overlay spinner
    _overlayKey.currentState!.show();

    // Create the new UsedFor document
    DocumentViewId? newUsedFor = await createUsedFor(
        sighting: this.widget.sighting, usedFor: usedFor.usedFor);

    // We want to wait until it is materialized and then refresh the
    // paginated query
    bool isReady = false;
    while (!isReady) {
      final options = QueryOptions(document: gql(usedForQuery(newUsedFor)));
      final result = await client.query(options);
      isReady = (result.data?['document'] != null);
      sleep(Duration(milliseconds: 100));
    }

    // Refresh the paginator
    this.paginator.refresh!();
    this.usedForTagPaginator.refresh!();

    // Hide the overlay
    _overlayKey.currentState!.hide();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isEditMode ? 500 : 250,
      child: LoadingOverlay(
        key: _overlayKey,
        child: EditableCard(
            title: AppLocalizations.of(context)!.usedForCardTitle,
            isEditMode: isEditMode,
            child: Container(
              height: isEditMode ? 400 : 150,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: PaginationUsedForList(
                        paginator: this.paginator,
                        builder: (List<UsedFor> uses) {
                          return UsedForList(
                              uses: uses,
                              isEditMode: this.isEditMode,
                              onDelete: this._delete);
                        },
                      ),
                    ),
                  ),
                  isEditMode
                      ? Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              children: [
                                Expanded(
                                  child: PaginationUsedForTagList(
                                      paginator: this.usedForTagPaginator,
                                      itemsBuilder: (List<UsedFor> uses) {
                                        return uses
                                            .map((usedFor) => UsedForTagItem(
                                                usedFor: usedFor,
                                                createUsedFor: _createUsedFor))
                                            .toList();
                                      }),
                                ),
                                _editableValue()
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            onChanged: _toggleEditMode),
      ),
    );
  }
}

class UsedForList extends StatelessWidget {
  final List<UsedFor> uses;
  final void Function(UsedFor usedFor) onDelete;
  final bool isEditMode;

  UsedForList(
      {super.key,
      required this.uses,
      this.isEditMode = false,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ...uses.map((usedFor) => Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: SizedBox(
            height: 20,
            child: Row(children: [
              Expanded(child: Text(usedFor.usedFor)),
              this.isEditMode
                  ? IconButton(
                      onPressed: () {
                        this.onDelete(usedFor);
                      },
                      icon: Icon(Icons.delete))
                  : SizedBox()
            ]),
          ))),
    ]);
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
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          this.createUsedFor(this.usedFor);
        },
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: Container(
            child: Text(usedFor.usedFor),
            margin: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }
}

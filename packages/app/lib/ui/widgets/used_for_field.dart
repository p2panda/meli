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
  late Paginator<UsedFor> paginator;
  final GlobalKey<LoadingOverlayState> _overlayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    paginator = UsedForPaginator(this.widget.sighting);
  }

  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  /// Contains changed value when user adjusted the field.
  AutocompleteItem? _dirty;

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
      isReady = (result.data != null);
      sleep(Duration(milliseconds: 150));
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
        // Make sure that we focus the text field and show the keyboard as soon
        // as we've entered "edit mode"
        autofocus: true,
        // Flip "edit mode" to false as soon as user hit the "submit" button on
        // the keyboard
        onSubmit: _toggleEditMode,
        onChanged: _changeValue);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: LoadingOverlay(
        key: _overlayKey,
        child: EditableCard(
            title: AppLocalizations.of(context)!.usedForCardTitle,
            isEditMode: isEditMode,
            child: Container(
              height: 100,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: PaginationList<UsedFor>(
                          builder: (UsedFor usedFor) {
                            return isEditMode
                                ? Text('${usedFor.usedFor} X')
                                : Text(usedFor.usedFor);
                          },
                          paginator: paginator),
                    ),
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

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:app/ui/widgets/used_for_list.dart';
import 'package:app/ui/widgets/used_for_tag_selector.dart';
import 'package:app/ui/widgets/used_for_text_field.dart';
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
  final GlobalKey<LoadingOverlayState> _overlayKey = GlobalKey();
  late Paginator<UsedFor> listPaginator =
      UsedForPaginator(sighting: widget.sighting);
  final Paginator<UsedFor> tagPaginator = UsedForPaginator();

  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

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

  void _createNewTag(String usedFor) async {
    await _createUse(usedFor);
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _onTagClick(String usedFor) async {
    await _createUse(usedFor);
  }

  @override
  Widget build(BuildContext context) {
    return EditableCard(
        title: AppLocalizations.of(context)!.usedForCardTitle,
        isEditMode: isEditMode,
        onChanged: _toggleEditMode,
        child: Container(
          constraints: BoxConstraints(maxHeight: isEditMode ? 500 : 120),
          child: LoadingOverlay(
            key: _overlayKey,
            child: Column(
              children: [
                SizedBox(
                    height: 120,
                    child: UsedForList(
                      paginator: listPaginator,
                      onDeleteClick: _deleteUse,
                      isEditMode: isEditMode,
                    )),
                ...(isEditMode
                    ? [
                        const SizedBox(height: 10),
                        Text("Add Uses",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        Expanded(
                            child: UsedForTagSelector(
                                paginator: tagPaginator,
                                onTagClick: _onTagClick)),
                        const SizedBox(height: 10),
                        Text("Create New Use",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        UsedForTextField(submit: _createNewTag)
                      ]
                    : [const SizedBox()])
              ],
            ),
          ),
        ));
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/save_cancel_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/loading_overlay.dart';
import 'package:app/ui/widgets/used_for_list.dart';
import 'package:app/ui/widgets/used_for_tag_selector.dart';
import 'package:app/ui/widgets/used_for_text_field.dart';

typedef OnUpdate = Future<DocumentViewId> Function(String);

class UsedForField extends StatefulWidget {
  final DocumentId sightingId;
  final VoidCallback onUpdate;

  const UsedForField(
      {super.key, required this.sightingId, required this.onUpdate});

  @override
  State<UsedForField> createState() => _UsedForFieldState();
}

class _UsedForFieldState extends State<UsedForField> {
  final GlobalKey<LoadingOverlayState> _overlayKey = GlobalKey();
  late Paginator<UsedFor> listPaginator =
      UsedForPaginator(sightings: [widget.sightingId]);
  final Paginator<UsedFor> tagPaginator = UsedForPaginator();

  /// Flag indicating if we're currently editing the field or not.
  bool isEditMode = false;

  Future<void> _createUse(String usedForString) async {
    // Show the overlay spinner
    _overlayKey.currentState!.show();

    // Create a new UsedFor document which relates to the current sighting.
    DocumentViewId usedforViewId = await createUsedFor(
        sighting: widget.sightingId, usedFor: usedForString);

    // We want to wait until it is materialized and then refresh the
    // paginated query
    bool isReady = false;
    while (!isReady) {
      final options = QueryOptions(document: gql(usedForQuery(usedforViewId)));
      final result = await client.query(options);
      isReady = (result.data?['document'] != null);
      sleep(const Duration(milliseconds: 100));
    }

    widget.onUpdate();

    // Refresh both paginators
    setState(() {});
    listPaginator.refresh!();

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

    widget.onUpdate();

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
        child: LoadingOverlay(
          key: _overlayKey,
          child: Column(
            children: [
              SizedBox(
                  height: 150,
                  child: SingleChildScrollView(
                      child: UsedForList(
                    paginator: listPaginator,
                    onDeleteClick: _deleteUse,
                    isEditMode: isEditMode,
                  ))),
              ...(isEditMode
                  ? [
                      // const SizedBox(height: 10),
                      // Text("Add Uses",
                      //     textAlign: TextAlign.center,
                      //     style: Theme.of(context).textTheme.titleLarge),
                      // const SizedBox(height: 10),
                      // Expanded(
                      //     child: SingleChildScrollView(
                      //   child: UsedForTagSelector(
                      //       paginator: tagPaginator, onTagClick: _onTagClick),
                      // )),
                      // const SizedBox(height: 10),
                      // Text("Create New Use",
                      //     textAlign: TextAlign.center,
                      //     style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      CreateCancelButtons(
                        handleCreate: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    insetPadding: const EdgeInsets.all(20.0),
                                    alignment: AlignmentDirectional.topCenter,
                                    child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Wrap(
                                          runSpacing: 10.0,
                                          children: [
                                            Text("Add Existing",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxHeight: 300.0),
                                                child: Scrollbar(
                                                  trackVisibility: true,
                                                  thumbVisibility: true,
                                                  child: SingleChildScrollView(
                                                      child: UsedForTagSelector(
                                                          onTagClick:
                                                              (String label) {
                                                    _createNewTag(label);
                                                    Navigator.pop(context);
                                                  })),
                                                )),
                                            Text("Create New",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            UsedForTextField(
                                              submit: (String label) {
                                                _createNewTag(label);
                                                Navigator.pop(context);
                                              },
                                              cancel: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )));
                              });
                        },
                        handleCancel: _toggleEditMode,
                      )
                    ]
                  : [const SizedBox()])
            ],
          ),
        ));
  }
}

class CreateCancelButtons extends StatelessWidget {
  final void Function()? handleCreate;
  final void Function()? handleCancel;

  const CreateCancelButtons({super.key, this.handleCreate, this.handleCancel});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(children: [
      OverflowBar(
        spacing: 10,
        overflowAlignment: OverflowBarAlignment.start,
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                foregroundColor: MeliColors.white,
                backgroundColor: MeliColors.plum),
            onPressed: handleCreate,
            child: Text('Add'),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  side: const BorderSide(width: 3.0, color: MeliColors.plum),
                  foregroundColor: MeliColors.plum),
              onPressed: handleCancel,
              child: Text(
                t.editCardCancelButton,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      )
    ]);
  }
}

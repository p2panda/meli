// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/utils/sleep.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';

import 'package:app/io/p2panda/documents.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/action_buttons.dart';
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
    // _overlayKey.currentState!.show();

    // Create a new UsedFor document which relates to the current sighting.
    DocumentViewId viewId = await createUsedFor(
        sighting: widget.sightingId, usedFor: usedForString);

    // We want to wait until it is materialized and then refresh the
    // paginated query
    await untilDocumentViewAvailable(SchemaIds.bee_attributes_used_for, viewId);

    widget.onUpdate();
    listPaginator.refresh!();
    // _overlayKey.currentState!.hide();

    setState(() {});
  }

  void _deleteUse(UsedFor usedFor) async {
    // _overlayKey.currentState!.show();

    // Delete the used for document.
    DocumentViewId viewId = await deleteUsedFor(usedFor.viewId);

    // We want to wait until the delete is materialized and then refresh the
    // paginated query
    // @TODO: Not working right now
    // await untilDocumentDeleted(SchemaIds.bee_attributes_used_for, viewId);
    await sleep(500);

    widget.onUpdate();
    listPaginator.refresh!();
    // _overlayKey.currentState!.hide();

    setState(() {});
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
    });
  }

  void _onAddedTag(String value) async {
    await _createUse(value);
  }

  @override
  Widget build(BuildContext context) {
    return EditableCard(
        title: AppLocalizations.of(context)!.usedForCardTitle,
        isEditMode: isEditMode,
        onChanged: _toggleEditMode,
        child: Column(children: [
          // @TODO: Needs to be fixed
          // LoadingOverlay(key: _overlayKey, child: Text('test')),
          UsedForList(
            paginator: listPaginator,
            onDeleteClick: _deleteUse,
            isEditMode: isEditMode,
          ),
          const SizedBox(height: 10.0),
          if (isEditMode)
            ActionButtons(
              actionLabel: "Add",
              onAction: () {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AddUsedForDialog(onAddedTag: _onAddedTag);
                    });
              },
              onCancel: _toggleEditMode,
            )
        ]));
  }
}

class AddUsedForDialog extends StatelessWidget {
  final void Function(String) onAddedTag;

  const AddUsedForDialog({super.key, required this.onAddedTag});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(20.0),
        alignment: AlignmentDirectional.topCenter,
        child: Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text("Add Existing",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Container(
                          width: constraints.maxWidth,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                              color: Colors.black12,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          child: ScrollShadow(
                            size: 8,
                            color: Colors.black.withOpacity(0.3),
                            child: Scrollbar(
                              trackVisibility: true,
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                  child: Container(
                                width: constraints.maxWidth,
                                padding: const EdgeInsets.all(10.0),
                                child: UsedForTagSelector(
                                    onTagClick: (String label) {
                                  onAddedTag(label);
                                  Navigator.pop(context);
                                }),
                              )),
                            ),
                          ));
                    }),
                  ),
                  const SizedBox(height: 20.0),
                  Text("Create New",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                  UsedForTextField(
                    onSubmit: (String label) {
                      onAddedTag(label);
                      Navigator.pop(context);
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )),
        ));
  }
}

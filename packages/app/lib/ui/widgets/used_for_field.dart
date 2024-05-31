// SPDX-License-Identifier: AGPL-3.0-or-later

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
import 'package:app/ui/widgets/used_for_list.dart';
import 'package:app/ui/widgets/used_for_tag_selector.dart';
import 'package:app/ui/widgets/used_for_text_field.dart';
import 'package:app/utils/sleep.dart';

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
  late Paginator<UsedFor> listPaginator =
      UsedForPaginator(sightings: [widget.sightingId]);
  final Paginator<UsedFor> tagPaginator = UsedForPaginator();

  bool isEditMode = false;
  bool isLoading = false;

  Future<void> _createUse(String usedForString) async {
    setState(() {
      isLoading = true;
    });

    // Create a new UsedFor document which relates to the current sighting.
    DocumentViewId viewId = await createUsedFor(
        sighting: widget.sightingId, usedFor: usedForString);

    // We want to wait until it is materialized and then refresh the
    // paginated query
    await untilDocumentViewAvailable(SchemaIds.bee_attributes_used_for, viewId);

    widget.onUpdate();
    listPaginator.refresh!();

    setState(() {
      isLoading = false;
    });
  }

  void _deleteUse(UsedFor usedFor) async {
    setState(() {
      isLoading = true;
    });

    // Delete the used for document.
    DocumentViewId viewId = await deleteUsedFor(usedFor.viewId);

    // We want to wait until the delete is materialized and then refresh the
    // paginated query
    // @TODO: Not working right now
    // await untilDocumentDeleted(SchemaIds.bee_attributes_used_for, viewId);
    await sleep(500);

    widget.onUpdate();
    listPaginator.refresh!();

    setState(() {
      isLoading = false;
    });
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
        UsedForList(
          paginator: listPaginator,
          onDeleteClick: _deleteUse,
          isLoading: isLoading,
          isEditMode: isEditMode,
        ),
        const SizedBox(height: 10.0),
        if (isEditMode)
          ActionButtons(
            actionLabel: "Add",
            onAction: isLoading
                ? null
                : () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AddUsedForDialog(onAddedTag: _onAddedTag);
                        });
                  },
            onCancel: isLoading ? null : _toggleEditMode,
          )
      ]),
    );
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: Text("Add Existing",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 7.0),
                    child: Text("Create New",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
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

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/tag_item.dart';

class UsedForTagSelector extends StatefulWidget {
  final void Function(String) onTagClick;

  const UsedForTagSelector({super.key, required this.onTagClick});

  @override
  State<UsedForTagSelector> createState() => _UsedForTagSelectorState();
}

class _UsedForTagSelectorState extends State<UsedForTagSelector> {
  Future<List<UsedFor>>? _aggregate;

  @override
  void initState() {
    super.initState();
    _aggregate = getAllDeduplicatedUsedFor();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsedFor>>(
        future: _aggregate,
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<UsedFor>> snapshot) {
          if (snapshot.hasError) {
            return ErrorCard(
                message: AppLocalizations.of(context)!
                    .paginationListError(snapshot.error.toString()));
          }

          if (snapshot.data!.isEmpty) {
            return Text(AppLocalizations.of(context)!.paginationListNoResults,
                textAlign: TextAlign.center);
          }

          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ...snapshot.data!.map((document) =>
                  TagItem(label: document.usedFor, onClick: widget.onTagClick)),
            ],
          );
        });
  }
}

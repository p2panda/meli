// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/models/used_for.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/tag_item.dart';

class UsedForTagSelector extends StatefulWidget {
  final void Function(String) onTagClick;

  const UsedForTagSelector({super.key, required this.onTagClick});

  @override
  State<UsedForTagSelector> createState() => _UsedForTagSelectorState();
}

class _UsedForTagSelectorState extends State<UsedForTagSelector> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsedFor>>(
        future: getAllDeduplicatedUsedFor(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List<UsedFor>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child: Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator(
                      color: MeliColors.black,
                    )));
          }

          if (snapshot.hasError) {
            return ErrorCard(
                message: AppLocalizations.of(context)!
                    .paginationListError(snapshot.error.toString()));
          }

          if (snapshot.data!.isEmpty) {
            return const SizedBox();
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

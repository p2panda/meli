// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:flutter/material.dart';

import 'package:app/models/base.dart';

class DeduplicatedUsedForTagsList extends StatelessWidget {
  final PaginationBuilder<UsedFor> builder;
  final Paginator<UsedFor> paginator;

  const DeduplicatedUsedForTagsList(
      {super.key, required this.builder, required this.paginator});

  @override
  Widget build(BuildContext context) {
    const minimumPageSize = 10;
    return PaginationBase<UsedFor>(
      fetchMoreOverride: (data) {
        // Collection queries over `UsedFor` documents will inevitably return
        // unwanted duplicate items which have the same "use".
        //
        // In this "fetch override" method we:
        // 1) deduplicate the returned collection
        // 2) if we haven't met the desired quota, signal that the next page
        //    should be fetched
        Set<String> seen = {};
        data.documents.retainWhere((usedFor) => seen.add(usedFor.usedFor));

        // We want to keep fetching more results (while there are any) until
        // we meet the minimum page size.
        return data.documents.length < minimumPageSize && data.hasNextPage;
      },
      paginator: this.paginator,
      builder: (List<UsedFor> collection) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ...collection.map((document) => this.builder(document)),
          ],
        );
      },
    );
  }
}

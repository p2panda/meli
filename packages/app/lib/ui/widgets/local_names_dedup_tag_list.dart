// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/models/local_names.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:app/models/base.dart';

class DeduplicatedLocalNamesList extends StatelessWidget {
  final PaginationBuilder<LocalName> builder;
  final Paginator<LocalName> paginator;
  final minimumPageSize = 10;

  const DeduplicatedLocalNamesList(
      {super.key, required this.builder, required this.paginator});

  bool _fetchMoreOverride(PaginatedCollection<LocalName> data) {
    // This collection queries all sightings, filtering by species id, and we
    // collect the first name in the `local_names` list field. This results in
    // duplicate local names being added to the list which are related to from
    // multiple sightings.
    //
    // In this "fetch override" method we:
    // 1) deduplicate the returned document collection items
    // 2) if we haven't met the desired quota, signal that the next page
    //    should be fetched
    Set<String> seen = {};
    data.documents.retainWhere((localName) => seen.add(localName.id));

    // We want to keep fetching more results (while there are any) until
    // we meet the minimum page size.
    return data.documents.length < minimumPageSize && data.hasNextPage;
  }

  @override
  Widget build(BuildContext context) {
    return PaginationBase<LocalName>(
      fetchMoreOverride: _fetchMoreOverride,
      paginator: paginator,
      builder: (List<LocalName> collection) {
        return Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ...collection.map((document) => builder(document)),
          ],
        );
      },
    );
  }
}

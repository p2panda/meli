// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/tag_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/used_for.dart';
import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';

typedef PaginationListBuilder = List<TagItem> Function(
  List<UsedFor> documents,
);

class InfiniteDedupTagsList extends StatefulWidget {
  final Paginator<UsedFor> paginator;
  final PaginationListBuilder itemsBuilder;

  const InfiniteDedupTagsList(
      {super.key, required this.paginator, required this.itemsBuilder});

  @override
  State<InfiniteDedupTagsList> createState() => _InfiniteDedupTagsListState();
}

class _InfiniteDedupTagsListState extends State<InfiniteDedupTagsList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initScrollController();
  }

  void _initScrollController() {
    scrollController.addListener(() {
      final scrollOffset = scrollController.offset;
      final maxOffset = scrollController.position.maxScrollExtent;
      if (scrollOffset >= maxOffset) {
        if (widget.paginator.fetchMore != null) {
          widget.paginator.fetchMore!();
        }
      }
    });
  }

  Widget _error(BuildContext context, String errorMessage) {
    return SingleChildScrollView(
      child: ErrorCard(
          message:
              AppLocalizations.of(context)!.paginationListError(errorMessage)),
    );
  }

  Widget _loading() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(15.0),
            child: const CircularProgressIndicator(
              color: MeliColors.black,
            )));
  }

  Widget _emptyResult(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Text(AppLocalizations.of(context)!.paginationListNoResults,
            style: const TextStyle(fontStyle: FontStyle.italic)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options:
          QueryOptions(document: widget.paginator.nextPageQuery(null)),
      builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        // Workaround to access `refetch` method from the outside
        widget.paginator.refresh ??= refetch;

        if (result.hasException) {
          return _error(context, result.exception.toString());
        }

        if (result.isLoading && result.data == null) {
          return _loading();
        }

        final data = widget
            .paginator
            .parseJSON(result.data as Map<String, dynamic>);

        if (data.documents.isEmpty) {
          return _emptyResult(context);
        }

        FetchMoreOptions opts = FetchMoreOptions(
          document: widget.paginator.nextPageQuery(data.endCursor),
          updateQuery: (previousResultData, fetchMoreResultData) {
            return widget
                .paginator
                .mergeResponses(previousResultData!, fetchMoreResultData!);
          },
        );

        // Get to access `fetchMore` method from the outside
        widget.paginator.fetchMore = () {
          if (data.hasNextPage) {
            fetchMore!(opts);
          }
        };

        // Deduplicate the returned collection.
        var seen = Set<String>();
        List<UsedFor> uniqueUses = data.documents
            .where((usedFor) => seen.add(usedFor.usedFor))
            .toList();

        // We want to keep fetching more results (while there are any) until
        // there are a minimum of 20.
        if (uniqueUses.length < 20 && data.hasNextPage) {
          fetchMore!(opts);
          return _loading();
        }

        return SingleChildScrollView(
            controller: scrollController,
            child: Wrap(children: [
              ...widget.itemsBuilder(uniqueUses),
            ]));
      },
    );
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/used_for.dart';
import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';

typedef NextPageFunction = DocumentNode Function(String endCursor);

typedef PaginationListBuilder = List<Widget> Function(
  List<UsedFor> documents,
);

class InfiniteScrollList extends StatefulWidget {
  final Paginator<UsedFor> paginator;
  final PaginationListBuilder builder;

  const InfiniteScrollList(
      {super.key, required this.paginator, required this.builder});

  @override
  State<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
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

        if (data.documents.isEmpty) {
          return _emptyResult(context);
        }

        return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                ...widget.builder(data.documents),
              ],
            ));
      },
    );
  }
}

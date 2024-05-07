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

  InfiniteScrollList(
      {super.key, required this.paginator, required this.builder});

  @override
  State<InfiniteScrollList> createState() => _InfiniteScrollListState();
}

class _InfiniteScrollListState extends State<InfiniteScrollList> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    this._initScrollController();
  }

  void _initScrollController() {
    scrollController.addListener(() {
      final _scrollOffset = scrollController.offset;
      final _maxOffset = scrollController.position.maxScrollExtent;
      if (_scrollOffset >= _maxOffset) {
        if (this.widget.paginator.fetchMore != null) {
          this.widget.paginator.fetchMore!();
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
            padding: EdgeInsets.all(15.0),
            child: CircularProgressIndicator(
              color: MeliColors.black,
            )));
  }

  Widget _emptyResult(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Text(AppLocalizations.of(context)!.paginationListNoResults,
            style: TextStyle(fontStyle: FontStyle.italic)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options:
          QueryOptions(document: this.widget.paginator.nextPageQuery(null)),
      builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (this.widget.paginator.refresh == null) {
          // Workaround to access `refetch` method from the outside
          this.widget.paginator.refresh = refetch;
        }

        if (result.hasException) {
          return this._error(context, result.exception.toString());
        }

        if (result.isLoading && result.data == null) {
          return this._loading();
        }

        final data = this
            .widget
            .paginator
            .parseJSON(result.data as Map<String, dynamic>);

        FetchMoreOptions opts = FetchMoreOptions(
          document: this.widget.paginator.nextPageQuery(data.endCursor),
          updateQuery: (previousResultData, fetchMoreResultData) {
            return this
                .widget
                .paginator
                .mergeResponses(previousResultData!, fetchMoreResultData!);
          },
        );

        // Get to access `fetchMore` method from the outside
        this.widget.paginator.fetchMore = () {
          if (data.hasNextPage) {
            fetchMore!(opts);
          }
        };

        if (data.documents.isEmpty) {
          return this._emptyResult(context);
        }

        return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                ...this.widget.builder(data.documents),
              ],
            ));
      },
    );
  }
}

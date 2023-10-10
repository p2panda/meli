// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/info_card.dart';

typedef NextPageFunction = DocumentNode Function(String endCursor);

typedef PaginationListBuilder<T> = Widget Function(
  T document,
);

class PaginationList<T> extends StatefulWidget {
  final PaginationListBuilder<T> builder;
  final Paginator<T> paginator;

  PaginationList({super.key, required this.builder, required this.paginator});

  @override
  State<PaginationList<T>> createState() => _PaginationListState<T>();
}

class _PaginationListState<T> extends State<PaginationList<T>> {
  Widget _error(BuildContext context, String errorMessage) {
    return ErrorCard(
        message:
            AppLocalizations.of(context)!.paginationListError(errorMessage));
  }

  Widget _loading() {
    return Center(
        child: Container(
            padding: EdgeInsets.all(30.0),
            child: CircularProgressIndicator(
              color: MeliColors.black,
            )));
  }

  Widget _emptyResult(BuildContext context) {
    return InfoCard(
        message: AppLocalizations.of(context)!.paginationListNoResults);
  }

  Widget _loadMore(BuildContext context, bool isLoading,
      {required VoidCallback onLoadMore}) {
    return Column(children: [
      isLoading
          ? this._loading()
          : ElevatedButton(
              child: Text(AppLocalizations.of(context)!.paginationListLoadMore,
                  style: TextStyle(color: MeliColors.black)),
              onPressed: onLoadMore,
            )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options:
          QueryOptions(document: this.widget.paginator.nextPageQuery(null)),
      builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (widget.paginator.onRefresh == null) {
          // Workaround to access `refetch` method from the outside
          widget.paginator.onRefresh = refetch;
        }

        if (result.hasException) {
          return this._error(context, result.exception.toString());
        }

        if (result.isLoading && result.data == null) {
          return this._loading();
        }

        final data =
            widget.paginator.parseJSON(result.data as Map<String, dynamic>);

        FetchMoreOptions opts = FetchMoreOptions(
          document: widget.paginator.nextPageQuery(data.endCursor),
          updateQuery: (previousResultData, fetchMoreResultData) {
            return widget.paginator
                .mergeResponses(previousResultData!, fetchMoreResultData!);
          },
        );

        if (data.documents.isEmpty) {
          return this._emptyResult(context);
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ...data.documents.map((document) => widget.builder(document)),
              if (data.hasNextPage)
                this._loadMore(context, result.isLoading, onLoadMore: () {
                  fetchMore!(opts);
                })
            ]);
      },
    );
  }
}

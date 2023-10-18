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
  List<T> documents,
);

typedef LoadMoreBuilder = Widget? Function(
    BuildContext context, VoidCallback onLoadMore);

class PaginationList<T> extends StatefulWidget {
  final PaginationListBuilder<T> listBuilder;
  final LoadMoreBuilder loadMoreBuilder;
  final Paginator<T> paginator;

  PaginationList(
      {super.key,
      required this.listBuilder,
      required this.paginator,
      required this.loadMoreBuilder});

  @override
  State<PaginationList<T>> createState() => _PaginationListState<T>();
}

class _PaginationListState<T> extends State<PaginationList<T>> {
  VoidCallback? fetchMore;

  Widget _error(BuildContext context, String errorMessage) {
    return ErrorCard(
        message:
            AppLocalizations.of(context)!.paginationListError(errorMessage));
  }

  Widget _loading() {
    return Center(
        child: Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator(
              color: MeliColors.black,
            )));
  }

  Widget _emptyResult(BuildContext context) {
    return InfoCard(
        message: AppLocalizations.of(context)!.paginationListNoResults);
  }

  Widget _loadMore(BuildContext context, bool isLoading) {
    return Column(children: [
      isLoading
          ? this._loading()
          : this.widget.loadMoreBuilder(context, this.fetchMore!) ?? SizedBox()
    ]);
  }

  //
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

        if (data.documents.isEmpty) {
          return this._emptyResult(context);
        }

        this.fetchMore = () {
          fetchMore!(opts);
        };

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              this.widget.listBuilder(data.documents),
              if (data.hasNextPage) this._loadMore(context, result.isLoading)
            ]);
      },
    );
  }
}

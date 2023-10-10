// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gql/ast.dart';

import 'package:app/models/base.dart';

typedef NextPageFunction = DocumentNode Function(String endCursor);

typedef PaginationListBuilder<T> = Widget Function(
  T document,
);

class PaginationList<T> extends StatelessWidget {
  final PaginationListBuilder<T> builder;
  final Paginator<T> paginator;

  PaginationList({super.key, required this.builder, required this.paginator});

  Widget _error(String errorMessage) {
    return Text(errorMessage);
  }

  Widget _loading() {
    return Text('Loading ...');
  }

  Widget _loadMore({required VoidCallback onLoadMore}) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Load More"),
        ],
      ),
      onPressed: onLoadMore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: this.paginator.nextPageQuery(null)),
      builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return this._error(result.exception.toString());
        }

        if (result.isLoading && result.data == null) {
          return this._loading();
        }

        final data =
            this.paginator.parseJSON(result.data as Map<String, dynamic>);

        FetchMoreOptions opts = FetchMoreOptions(
          document: this.paginator.nextPageQuery(data.endCursor),
          updateQuery: (previousResultData, fetchMoreResultData) {
            return this
                .paginator
                .mergeResponses(previousResultData!, fetchMoreResultData!);
          },
        );

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ...data.documents.map((document) => this.builder(document)),
              if (data.hasNextPage)
                this._loadMore(onLoadMore: () {
                  fetchMore!(opts);
                })
            ]);
      },
    );
  }
}

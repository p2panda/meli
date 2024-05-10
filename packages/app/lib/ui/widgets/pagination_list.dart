// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/info_card.dart';

typedef NextPageFunction = DocumentNode Function(String endCursor);

typedef PaginationBuilder<T> = Widget Function(
  T document,
);

typedef ContainerBuilder<T> = Widget Function(
  List<T> collection,
);

class PaginationBase<T> extends StatelessWidget {
  final ContainerBuilder<T> builder;
  final Paginator<T> paginator;

  const PaginationBase(
      {super.key, required this.builder, required this.paginator});

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

  Widget _loadMore(BuildContext context, bool isLoading,
      {required VoidCallback onLoadMore}) {
    return Column(children: [
      isLoading
          ? this._loading()
          : ElevatedButton(
              onPressed: onLoadMore,
              child: Text(AppLocalizations.of(context)!.paginationListLoadMore,
                  style: const TextStyle(color: MeliColors.black)),
            )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: this.paginator.nextPageQuery(null)),
      builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (this.paginator.refresh == null) {
          // Workaround to access `refetch` method from the outside
          this.paginator.refresh = refetch;
        }

        if (result.hasException) {
          return this._error(context, result.exception.toString());
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

        if (data.documents.isEmpty) {
          return this._emptyResult(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            this.builder(data.documents),
            if (data.hasNextPage)
              this._loadMore(context, result.isLoading, onLoadMore: () {
                fetchMore!(opts);
              })
          ],
        );
      },
    );
  }
}

class SliverPaginationBase<T> extends StatelessWidget {
  final ContainerBuilder<T> builder;
  final Paginator<T> paginator;

  const SliverPaginationBase(
      {super.key, required this.builder, required this.paginator});

  Widget _error(BuildContext context, String errorMessage) {
    return SliverToBoxAdapter(
        child: ErrorCard(
            message: AppLocalizations.of(context)!
                .paginationListError(errorMessage)));
  }

  Widget _loading() {
    return SliverToBoxAdapter(
        child: Center(
            child: Container(
                padding: const EdgeInsets.all(30.0),
                child: const CircularProgressIndicator(
                  color: MeliColors.black,
                ))));
  }

  Widget _emptyResult(BuildContext context) {
    return SliverToBoxAdapter(
        child: InfoCard(
            message: AppLocalizations.of(context)!.paginationListNoResults));
  }

  Widget _loadMore(BuildContext context, bool isLoading,
      {required VoidCallback onLoadMore}) {
    return MultiSliver(children: [
      const SizedBox(height: 20.0),
      isLoading
          ? this._loading()
          : Center(
              child: ElevatedButton(
              onPressed: onLoadMore,
              child: Text(AppLocalizations.of(context)!.paginationListLoadMore,
                  style: const TextStyle(color: MeliColors.black)),
            ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: this.paginator.nextPageQuery(null)),
      builder: (result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (this.paginator.refresh == null) {
          // Workaround to access `refetch` method from the outside
          this.paginator.refresh = refetch;
        }

        if (result.hasException) {
          return this._error(context, result.exception.toString());
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

        if (data.documents.isEmpty) {
          return this._emptyResult(context);
        }

        return MultiSliver(children: [
          this.builder(data.documents),
          if (data.hasNextPage)
            this._loadMore(context, result.isLoading, onLoadMore: () {
              fetchMore!(opts);
            })
        ]);
      },
    );
  }
}

class PaginationList<T> extends StatelessWidget {
  final PaginationBuilder<T> builder;
  final Paginator<T> paginator;

  const PaginationList(
      {super.key, required this.builder, required this.paginator});

  @override
  Widget build(BuildContext context) {
    return PaginationBase<T>(
      paginator: this.paginator,
      builder: (List<T> collection) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ...collection.map((document) => this.builder(document)),
          ],
        );
      },
    );
  }
}

class PaginationGrid<T> extends StatelessWidget {
  final PaginationBuilder<T> builder;
  final Paginator<T> paginator;

  const PaginationGrid(
      {super.key, required this.builder, required this.paginator});

  @override
  Widget build(BuildContext context) {
    return SliverPaginationBase<T>(
      paginator: this.paginator,
      builder: (List<T> collection) {
        return SliverGrid.builder(
          itemCount: collection.length,
          itemBuilder: (BuildContext context, int index) {
            return this.builder(collection[index]);
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        );
      },
    );
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/used_for.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';

import 'info_card.dart';

class DedupUsedForPaginationBase extends StatelessWidget {
  final ContainerBuilder<UsedFor> builder;
  final Paginator<UsedFor> paginator;

  const DedupUsedForPaginationBase(
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

        // Deduplicate the returned collection.
        Set<String> seen = {};
        List<UsedFor> uniqueUses = data.documents
            .where((usedFor) => seen.add(usedFor.usedFor))
            .toList();

        // We want to keep fetching more results (while there are any) until
        // there are a minimum of 20.
        if (uniqueUses.length < 20 && data.hasNextPage) {
          fetchMore!(opts);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            this.builder(uniqueUses),
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

class DeduplicatedUsedForTagsList extends StatelessWidget {
  final PaginationBuilder<UsedFor> builder;
  final Paginator<UsedFor> paginator;

  const DeduplicatedUsedForTagsList(
      {super.key, required this.builder, required this.paginator});

  @override
  Widget build(BuildContext context) {
    return DedupUsedForPaginationBase(
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

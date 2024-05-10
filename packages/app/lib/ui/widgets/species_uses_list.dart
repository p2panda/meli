// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/sightings.dart';
import 'package:app/ui/widgets/pagination_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';

import 'info_card.dart';

class SpeciesUsesPaginationBase extends StatelessWidget {
  final ContainerBuilder<Sighting> builder;
  final Paginator<Sighting> paginator;

  const SpeciesUsesPaginationBase(
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

        if (data.hasNextPage) {
          fetchMore!(opts);
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

class SpeciesUsedForList extends StatelessWidget {
  final Paginator<Sighting> paginator;
  final PaginationBuilder<List<Sighting>> builder;

  const SpeciesUsedForList({
    super.key,
    required this.paginator,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SpeciesUsesPaginationBase(
      paginator: this.paginator,
      builder: this.builder,
    );
  }
}

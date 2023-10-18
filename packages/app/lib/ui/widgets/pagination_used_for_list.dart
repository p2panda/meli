// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/used_for.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/models/base.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/error_card.dart';
import 'package:app/ui/widgets/info_card.dart';

typedef NextPageFunction = DocumentNode Function(String endCursor);

class PaginationUsedForList extends StatefulWidget {
  final Paginator<UsedFor> paginator;
  final void Function(UsedFor) onDelete;

  PaginationUsedForList(
      {super.key, required this.paginator, required this.onDelete});

  @override
  State<PaginationUsedForList> createState() => _PaginationUsedForListState();
}

class _PaginationUsedForListState extends State<PaginationUsedForList> {
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
    return ErrorCard(
        message:
            AppLocalizations.of(context)!.paginationListError(errorMessage));
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
    return InfoCard(
        message: AppLocalizations.of(context)!.paginationListNoResults);
  }

  Widget _loadMore(BuildContext context, bool isLoading) {
    return Column(children: [isLoading ? this._loading() : Text("...")]);
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
                UsedForList(
                    uses: data.documents, onDelete: this.widget.onDelete),
                if (data.hasNextPage) this._loadMore(context, result.isLoading)
              ],
            ));
      },
    );
  }
}

class UsedForList extends StatelessWidget {
  final List<UsedFor> uses;
  final void Function(UsedFor usedFor) onDelete;
  final bool isEditMode;

  UsedForList(
      {super.key,
      required this.uses,
      this.isEditMode = false,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ...uses.map((usedFor) => Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: SizedBox(
            height: 30,
            child: Row(children: [
              Expanded(child: Text(usedFor.usedFor)),
              this.isEditMode
                  ? IconButton(
                      onPressed: () {
                        this.onDelete(usedFor);
                      },
                      icon: Icon(Icons.delete))
                  : SizedBox()
            ]),
          ))),
    ]);
  }
}

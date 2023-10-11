// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:gql/ast.dart';

class PaginatedCollection<T> {
  final List<T> documents;
  final bool hasNextPage;
  final String? endCursor;

  PaginatedCollection(
      {required this.documents, required this.hasNextPage, this.endCursor});
}

abstract class Paginator<T> {
  /// Call this method to force refreshing a `PaginationList` widget using this
  /// Paginator instance.
  VoidCallback? refresh;

  /// Should return GraphQL query for the next page.
  DocumentNode nextPageQuery(String? cursor);

  /// Method to decode an incoming JSON string into structured data.
  PaginatedCollection<T> parseJSON(Map<String, dynamic> json);

  /// Combine results from previous queries and new data for the UI. Needs to be
  /// overwritten when result key is different than `results`.
  Map<String, dynamic> mergeResponses(
      Map<String, dynamic> previous, Map<String, dynamic> next) {
    final List<dynamic> documents = [
      ...previous['results']['documents'] as List<dynamic>,
      ...next['results']['documents'] as List<dynamic>
    ];
    next['results']['documents'] = documents;
    return next;
  }
}

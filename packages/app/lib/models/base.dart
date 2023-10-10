// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:gql/ast.dart';

class PaginatedCollection<T> {
  final List<T> documents;
  final bool hasNextPage;
  final String? endCursor;

  PaginatedCollection(
      {required this.documents, required this.hasNextPage, this.endCursor});
}

abstract class Paginator<T> {
  DocumentNode nextPageQuery(String? cursor);

  PaginatedCollection<T> parseJSON(Map<String, dynamic> json);

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

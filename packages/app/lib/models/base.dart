// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:ui';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/io/p2panda/schemas.dart';

const DEFAULT_PAGE_SIZE = 10;

const DEFAULT_RESULTS_KEY = 'collection';

String get paginationFields {
  return '''
    endCursor
    hasNextPage
  ''';
}

String get metaFields {
  return '''
    meta {
      owner
      documentId
      viewId
    }
  ''';
}

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

  VoidCallback? fetchMore;

  /// Should return GraphQL query for the next page.
  DocumentNode nextPageQuery(String? cursor);

  /// Method to decode an incoming JSON string into structured data.
  PaginatedCollection<T> parseJSON(Map<String, dynamic> json);

  /// Combine results from previous queries and new data for the UI. Needs to be
  /// overwritten when result key is different than the default result key.
  Map<String, dynamic> mergeResponses(
      Map<String, dynamic> previous, Map<String, dynamic> next) {
    final List<dynamic> documents = [
      ...previous[DEFAULT_RESULTS_KEY]['documents'] as List<dynamic>,
      ...next[DEFAULT_RESULTS_KEY]['documents'] as List<dynamic>
    ];
    next[DEFAULT_RESULTS_KEY]['documents'] = documents;
    return next;
  }
}

Future<List<Map<String, dynamic>>> paginateOverEverything(
    SchemaId schemaId, String fields,
    {String filter = '', int pageSize = DEFAULT_PAGE_SIZE}) async {
  String filterStr = filter.isNotEmpty ? "filter: { $filter }," : "";

  bool hasNextPage = true;
  String? endCursor;
  List<Map<String, dynamic>> documents = [];

  while (hasNextPage) {
    final afterStr = endCursor != null ? "after: \"$endCursor\"," : "";
    final document = '''
      query PaginateOverEverything {
        all_$schemaId(
          first: $pageSize,
          $afterStr
          $filterStr
        ) {
          $paginationFields
          documents {
            meta {
              $metaFields
            }
            fields {
              $fields
            }
          }
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(document)));
    if (result.hasException) {
      throw "Error during pagination: ${result.exception}";
    }

    endCursor = result.data!['endCursor'] as String;
    hasNextPage = result.data!['hasNextPage'] as bool;
    documents.addAll(result.data!['documents'] as List<Map<String, dynamic>>);
  }

  return documents;
}

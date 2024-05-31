// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/utils/sleep.dart';

/// Returns true if document is materialized with the specified view id.
Future<bool> isDocumentViewAvailable(
    SchemaId schemaId, DocumentViewId viewId) async {
  String query = '''
    query CheckDocumentStatus() {
      status: all_$schemaId(meta: { viewId: { eq: "$viewId" } }) {
        totalCount
      }
    }
  ''';

  final options = QueryOptions(document: gql(query));
  final result = await client.query(options);

  if (result.hasException) {
    throw "Error while querying if document view was materialized on node";
  }

  final status = result.data?['status'] as Map<String, dynamic>;
  return status['totalCount'] == 1;
}

/// Returns true if document is deleted.
Future<bool> isDocumentDeleted(SchemaId schemaId, DocumentViewId viewId) async {
  String query = '''
    query CheckDocumentStatus() {
      status: all_$schemaId(meta: { viewId: { eq: "$viewId" }, deleted: { eq: true }) {
        totalCount
      }
    }
  ''';

  final options = QueryOptions(document: gql(query));
  final result = await client.query(options);

  if (result.hasException) {
    throw "Error while querying if document view was materialized on node";
  }

  final status = result.data?['status'] as Map<String, dynamic>;
  return status['totalCount'] == 1;
}

/// Async helper method to block until node materialized document to a
/// specific view id.
Future<void> untilDocumentViewAvailable(
    SchemaId schemaId, DocumentViewId viewId) async {
  while (true) {
    if (await isDocumentViewAvailable(schemaId, viewId)) {
      break;
    } else {
      sleep(250);
    }
  }
}

/// Async helper method to block until node deleted a document.
Future<void> untilDocumentDeleted(
    SchemaId schemaId, DocumentViewId viewId) async {
  while (true) {
    if (await isDocumentDeleted(schemaId, viewId)) {
      break;
    } else {
      sleep(250);
    }
  }
}

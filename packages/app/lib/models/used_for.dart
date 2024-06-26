// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

class UsedFor {
  final DocumentId id;
  DocumentViewId viewId;

  DocumentId? sighting;
  String usedFor;

  UsedFor(
      {required this.id,
      required this.viewId,
      required this.sighting,
      required this.usedFor});

  factory UsedFor.fromJson(Map<String, dynamic> result) {
    return UsedFor(
        id: result['meta']['documentId'] as DocumentId,
        viewId: result['meta']['viewId'] as DocumentViewId,
        sighting: result['fields']['sighting'] != null
            ? result['fields']['sighting']['meta']['documentId'] as DocumentId
            : null,
        usedFor: result['fields']['used_for'] as String);
  }

  static Future<UsedFor> create(
      {required DocumentId sighting, required String usedFor}) async {
    DocumentViewId viewId =
        await createUsedFor(sighting: sighting, usedFor: usedFor);
    return UsedFor(
      id: viewId,
      viewId: viewId,
      sighting: sighting,
      usedFor: usedFor,
    );
  }

  Future<DocumentViewId> delete() async {
    viewId = await deleteUsedFor(viewId);
    return viewId;
  }
}

String get usedForFields {
  return '''
    $metaFields
    fields {
      used_for
      sighting {
        meta {
          documentId
        }
      }
    }
  ''';
}

String usedForQuery(DocumentId id) {
  const schemaId = SchemaIds.bee_attributes_used_for;

  return '''
    query usedForQuery {
      document: $schemaId(id: "$id") {
        $usedForFields
      }
    }
  ''';
}

class UsedForPaginator extends Paginator<UsedFor> {
  final List<DocumentId>? sightings;

  UsedForPaginator({this.sightings});

  @override
  DocumentNode nextPageQuery(String? cursor) {
    return gql(allUsesQuery(sightings, cursor));
  }

  @override
  PaginatedCollection<UsedFor> parseJSON(Map<String, dynamic> json) {
    final list = json[DEFAULT_RESULTS_KEY]['documents'] as List;
    final documents = list
        .map((sighting) => UsedFor.fromJson(sighting as Map<String, dynamic>))
        .toList();

    final endCursor = json[DEFAULT_RESULTS_KEY]['endCursor'] as String?;
    final hasNextPage = json[DEFAULT_RESULTS_KEY]['hasNextPage'] as bool;

    return PaginatedCollection(
        documents: documents, hasNextPage: hasNextPage, endCursor: endCursor);
  }
}

Future<List<UsedFor>> getAllDeduplicatedUsedFor() async {
  final jsonDocuments = await paginateOverEverything(
      SchemaIds.bee_attributes_used_for, usedForFields);

  List<UsedFor> documents = [];
  for (var json in jsonDocuments) {
    final usedFor = UsedFor.fromJson(json);
    documents.add(usedFor);
  }

  // De-Duplicate documents by removing duplicate "used-for" strings
  Set<String> seen = {};
  documents.retainWhere((usedFor) => seen.add(usedFor.usedFor));

  return documents;
}

String allUsesQuery(List<DocumentId>? sightings, String? cursor) {
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  String filter = '';
  if (sightings != null) {
    String sightingsString =
        sightings.map((sighting) => '''"$sighting"''').join(", ");
    filter = '''filter: { sighting: { in: [$sightingsString] } },''';
  }
  const schemaId = SchemaIds.bee_attributes_used_for;

  return '''
    query AllUses {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        $filter
        first: $DEFAULT_PAGE_SIZE,
        $after
        orderBy: "used_for",
        orderDirection: ASC
      ) {
        $paginationFields
        documents {
          $usedForFields
        }
      }
    }
  ''';
}

Future<DocumentViewId> createUsedFor(
    {required DocumentId sighting, required String usedFor}) async {
  List<(String, OperationValue)> fields = [
    ("sighting", OperationValue.relation(sighting)),
    ("used_for", OperationValue.string(usedFor)),
  ];
  return await create(SchemaIds.bee_attributes_used_for, fields);
}

Future<DocumentViewId> deleteUsedFor(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_attributes_used_for, viewId);
}

Future<void> deleteAllUsedFor(DocumentId sightingId) async {
  final jsonDocuments = await paginateOverEverything(
      SchemaIds.bee_attributes_used_for, usedForFields,
      filter: 'sighting: { eq: "$sightingId" }');

  for (var json in jsonDocuments) {
    await UsedFor.fromJson(json).delete();
  }
}

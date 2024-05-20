// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:gql/ast.dart';
import 'package:graphql/client.dart';
import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

class LocalName {
  final DocumentId id;
  DocumentViewId viewId;

  String name;

  LocalName({required this.id, required this.viewId, required this.name});

  factory LocalName.fromJson(Map<String, dynamic> json) {
    return LocalName(
        id: json['meta']['documentId'] as DocumentId,
        viewId: json['meta']['viewId'] as DocumentViewId,
        name: json['fields']['name'] as String);
  }

  static Future<LocalName> create({required String name}) async {
    DocumentViewId viewId = await createLocalName(name: name);
    return LocalName(
      id: viewId,
      viewId: viewId,
      name: name,
    );
  }

  Future<DocumentViewId> update({required String name}) async {
    viewId = await updateLocalName(viewId, name: name);
    this.name = name;
    return viewId;
  }

  Future<DocumentViewId> delete() async {
    viewId = await deleteLocalName(viewId);
    return viewId;
  }
}

String get localNameFields {
  return '''
    $metaFields
    fields {
      name
    }
  ''';
}

String searchLocalNamesQuery(String query) {
  const schemaId = SchemaIds.bee_local_name;

  return '''
    query SearchLocalNames {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: 5,
        filter: {
          name: { contains: "$query" },
        },
        orderBy: "name",
        orderDirection: ASC,
      ) {
        documents {
          $localNameFields
        }
      }
    }
  ''';
}

Future<DocumentViewId> createLocalName({required String name}) async {
  List<(String, OperationValue)> fields = [
    ("name", OperationValue.string(name)),
  ];
  return await create(SchemaIds.bee_local_name, fields);
}

Future<DocumentViewId> updateLocalName(DocumentViewId viewId,
    {required String name}) async {
  List<(String, OperationValue)> fields = [
    ("name", OperationValue.string(name)),
  ];
  return await update(viewId, SchemaIds.bee_local_name, fields);
}

Future<DocumentViewId> deleteLocalName(DocumentViewId viewId) async {
  return await delete(viewId, SchemaIds.bee_local_name);
}

class UsedForPaginator extends Paginator<LocalName> {
  final List<DocumentId>? sightings;

  UsedForPaginator({this.sightings});

  @override
  DocumentNode nextPageQuery(String? cursor) {
    return gql(allLocalNames(sightings, cursor));
  }

  @override
  PaginatedCollection<LocalName> parseJSON(Map<String, dynamic> json) {
    final list = json[DEFAULT_RESULTS_KEY]['documents'] as List;
    final documents = list
        .map((sighting) => LocalName.fromJson(sighting as Map<String, dynamic>))
        .toList();

    final endCursor = json[DEFAULT_RESULTS_KEY]['endCursor'] as String?;
    final hasNextPage = json[DEFAULT_RESULTS_KEY]['hasNextPage'] as bool;

    return PaginatedCollection(
        documents: documents, hasNextPage: hasNextPage, endCursor: endCursor);
  }
}

String allLocalNames(List<DocumentId>? sightings, String? cursor) {
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
          $localNameFields
        }
      }
    }
  ''';
}

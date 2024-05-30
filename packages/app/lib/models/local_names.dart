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

class LocalNamesPaginator extends Paginator<LocalName> {
  final DocumentId species;

  LocalNamesPaginator({required this.species});

  @override
  DocumentNode nextPageQuery(String? cursor) {
    return gql(allSpeciesLocalNames(cursor, species));
  }

  @override
  PaginatedCollection<LocalName> parseJSON(Map<String, dynamic> json) {
    final list = json[DEFAULT_RESULTS_KEY]['documents'] as List;
    final documents = list
        .where((sighting) {
          List<dynamic> local_names =
              sighting['fields']['local_names']['documents'] as List;
          return local_names.isNotEmpty && local_names[0] != null;
        })
        .map((sighting) => LocalName.fromJson(sighting['fields']['local_names']
            ['documents'][0] as Map<String, dynamic>))
        .toList();

    final endCursor = json[DEFAULT_RESULTS_KEY]['endCursor'] as String?;
    final hasNextPage = json[DEFAULT_RESULTS_KEY]['hasNextPage'] as bool;

    return PaginatedCollection(
        documents: documents, hasNextPage: hasNextPage, endCursor: endCursor);
  }
}

String allSpeciesLocalNames(String? cursor, DocumentId? speciesId) {
  const schemaId = SchemaIds.bee_sighting;
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  final filter = (speciesId != null)
      ? '''filter: { species: { in: ["$speciesId"] } },'''
      : '';

  return '''
    query SpeciesLocalNames {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: $DEFAULT_PAGE_SIZE,
        $after
        $filter
        orderBy: "datetime",
        orderDirection: DESC
      ) {
        $paginationFields
        documents {
          fields {
            local_names {
              documents {
                $localNameFields
              }
            }
          }
        }
      }
    }
  ''';
}

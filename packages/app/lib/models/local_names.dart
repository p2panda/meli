// SPDX-License-Identifier: AGPL-3.0-or-later

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
    this.viewId = await updateLocalName(this.viewId, name: name);
    this.name = name;
    return this.viewId;
  }

  Future<DocumentViewId> delete() async {
    this.viewId = await deleteLocalName(this.viewId);
    return this.viewId;
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
  final schemaId = SchemaIds.bee_local_name;

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

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

class LocalName {
  final String id;
  final String name;

  LocalName({required this.id, required this.name});

  factory LocalName.fromJson(Map<String, dynamic> result) {
    return LocalName(
        id: result['meta']['documentId'] as String,
        name: result['fields']['name'] as String);
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

Future<DocumentViewId> createLocalName(String name) async {
  List<(String, OperationValue)> fields = [
    ("name", OperationValue.string(name)),
  ];
  return await create(SchemaIds.bee_local_name, fields);
}

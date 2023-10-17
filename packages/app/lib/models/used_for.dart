// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

class UsedFor {
  final DocumentId id;
  DocumentViewId viewId;
  DocumentId sighting;
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
        sighting:
            result['fields']['sighting']['meta']['documentId'] as DocumentId,
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

  Future<DocumentViewId> update({DocumentId? sighting, String? usedFor}) async {
    this.viewId =
        await updateUsedFor(this.viewId, sighting: sighting, usedFor: usedFor);
    if (sighting != null) {
      this.sighting = sighting;
    }

    if (usedFor != null) {
      this.usedFor = usedFor;
    }

    return this.viewId;
  }

  Future<DocumentViewId> delete() async {
    this.viewId = await deleteUsedFor(this.viewId);
    return this.viewId;
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

String searchUsedForQuery(String query) {
  final schemaId = SchemaIds.bee_attributes_used_for;

  return '''
    query SearchUsedFor {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: 5,
        filter: {
          used_for: { contains: "$query" },
        },
        orderBy: "used_for",
        orderDirection: ASC,
      ) {
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

Future<DocumentViewId> updateUsedFor(DocumentViewId viewId,
    {DocumentId? sighting, String? usedFor}) async {
  List<(String, OperationValue)> fields = [];

  if (sighting != null) {
    fields.add(("sighting", OperationValue.relation(sighting)));
  }

  if (usedFor != null) {
    fields.add(("used_for", OperationValue.string(usedFor)));
  }

  return await update(viewId, SchemaIds.bee_attributes_used_for, fields);
}

Future<DocumentViewId> deleteUsedFor(DocumentViewId viewId) async {
  return await delete(viewId, SchemaIds.bee_attributes_used_for);
}

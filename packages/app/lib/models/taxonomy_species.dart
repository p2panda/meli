// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart' as publish;
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

class BaseTaxonomy {
  final SchemaId schemaId;

  publish.DocumentId id;
  publish.DocumentViewId viewId;
  String name;

  BaseTaxonomy(this.schemaId,
      {required this.id, required this.viewId, required this.name});

  factory BaseTaxonomy.fromJson(SchemaId schemaId, Map<String, dynamic> json) {
    return BaseTaxonomy(schemaId,
        id: json['meta']['documentId'] as publish.DocumentId,
        viewId: json['meta']['viewId'] as publish.DocumentViewId,
        name: json['fields']['name'] as String);
  }

  Future<publish.DocumentViewId> update({required String name}) async {
    this.viewId = await updateTaxon(this.schemaId, this.viewId, name: name);
    this.name = name;
    return this.viewId;
  }

  Future<publish.DocumentViewId> delete() async {
    this.viewId = await deleteTaxon(this.schemaId, this.viewId);
    return this.viewId;
  }
}

class TaxonomySpecies extends BaseTaxonomy {
  static SchemaId SCHEMA_ID = SchemaIds.taxonomy_species;

  TaxonomySpecies(BaseTaxonomy base)
      : super(SCHEMA_ID, id: base.id, viewId: base.viewId, name: base.name);

  factory TaxonomySpecies.fromJson(Map<String, dynamic> json) {
    return TaxonomySpecies(BaseTaxonomy.fromJson(SCHEMA_ID, json));
  }

  static Future<BaseTaxonomy> create({required String name}) async {
    final id = await createTaxon(SCHEMA_ID, name: name);
    return TaxonomySpecies(
        BaseTaxonomy(SCHEMA_ID, id: id, viewId: id, name: name));
  }
}

String get taxonomySpeciesFields {
  return '''
    $metaFields
    fields {
      name
    }
  ''';
}

Future<publish.DocumentViewId> createTaxon(SchemaId schemaId,
    {required String name}) async {
  List<(String, OperationValue)> fields = [
    ("name", OperationValue.string(name)),
  ];
  return await publish.create(schemaId, fields);
}

Future<publish.DocumentViewId> updateTaxon(
    SchemaId schemaId, publish.DocumentViewId viewId,
    {required String name}) async {
  List<(String, OperationValue)> fields = [
    ("name", OperationValue.string(name)),
  ];
  return await publish.update(schemaId, viewId, fields);
}

Future<publish.DocumentViewId> deleteTaxon(
    SchemaId schemaId, publish.DocumentViewId viewId) async {
  return await publish.delete(schemaId, viewId);
}

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

  Future<String> search(String value) async {
    return '';
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

String get taxonomyFields {
  return '''
    $metaFields
    fields {
      name
    }
  ''';
}

String get speciesFields {
  return '''
    $metaFields
    fields {
      name
      genus {
        $genusFields
      }
    }
  ''';
}

String get genusFields {
  return '''
    $metaFields
    fields {
      name
      tribe {
        $tribeFields
      }
    }
  ''';
}

String get tribeFields {
  return '''
    $metaFields
    fields {
      name
      subfamily {
        $subfamilyFields
      }
    }
  ''';
}

String get subfamilyFields {
  return '''
    $metaFields
    fields {
      name
      family {
        $familyFields
      }
    }
  ''';
}

String get familyFields {
  return '''
    $metaFields
    fields {
      name
      order {
        $orderFields
      }
    }
  ''';
}

String get orderFields {
  return '''
    $metaFields
    fields {
      name
      class {
        $classFields
      }
    }
  ''';
}

String get classFields {
  return '''
    $metaFields
    fields {
      name
      phylum {
        $phylumFields
      }
    }
  ''';
}

String get phylumFields {
  return '''
    $metaFields
    fields {
      name
      kingdom {
        $kingdomFields
      }
    }
  ''';
}

String get kingdomFields {
  return '''
    $metaFields
    fields {
      name
    }
  ''';
}

final RANKS = [
  {'fields': speciesFields, 'schemaId': SchemaIds.taxonomy_species},
  {'fields': genusFields, 'schemaId': SchemaIds.taxonomy_genus},
  {'fields': tribeFields, 'schemaId': SchemaIds.taxonomy_tribe},
  {'fields': subfamilyFields, 'schemaId': SchemaIds.taxonomy_subfamily},
  {'fields': familyFields, 'schemaId': SchemaIds.taxonomy_family},
  {'fields': orderFields, 'schemaId': SchemaIds.taxonomy_order},
  {'fields': classFields, 'schemaId': SchemaIds.taxonomy_class},
  {'fields': phylumFields, 'schemaId': SchemaIds.taxonomy_phylum},
  {'fields': kingdomFields, 'schemaId': SchemaIds.taxonomy_kingdom},
];

String getTaxonomy(int rank, publish.DocumentId documentId) {
  final schemaId = RANKS[rank]['schemaId'];
  final fields = RANKS[rank]['fields'];

  return '''
    query GetTaxonomy {
      $DEFAULT_RESULTS_KEY: $schemaId(id: $documentId) {
        $fields
      }
    }
  ''';
}

String searchTaxon(SchemaId schemaId, String query) {
  return '''
    query SearchTaxon {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: 5,
        filter: {
          name: { contains: "$query" },
        },
        orderBy: "name",
        orderDirection: ASC,
      ) {
        documents {
          $taxonomyFields
        }
      }
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

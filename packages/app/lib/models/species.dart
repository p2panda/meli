// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/graphql/queries.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/taxonomy_species.dart';

class Species {
  final DocumentId id;
  DocumentViewId viewId;

  TaxonomySpecies species;
  String description;

  Species(
      {required this.id,
      required this.viewId,
      required this.species,
      required this.description});

  factory Species.fromJson(Map<String, dynamic> result) {
    return Species(
        id: result['meta']['documentId'] as DocumentId,
        viewId: result['meta']['viewId'] as DocumentViewId,
        species: TaxonomySpecies.fromJson(
            result['fields']['species'] as Map<String, dynamic>),
        description: result['fields']['description'] as String);
  }

  static Future<Species> upsert(TaxonomySpecies taxon) async {
    // Check if species already exists with this taxon
    final json = await query(query: firstSpeciesWithTaxon(taxon.id));
    final list = json[DEFAULT_RESULTS_KEY]['documents'] as List;

    if (list.isNotEmpty) {
      // Return existing one
      return Species.fromJson(list[0] as Map<String, dynamic>);
    } else {
      // Create new species and then return it
      final id = await createSpecies(taxonomySpeciesId: taxon.id);
      return Species(id: id, viewId: id, species: taxon, description: '');
    }
  }

  Future<DocumentViewId> update({
    TaxonomySpecies? species,
    String? description,
  }) async {
    DocumentId? taxonomySpeciesId;
    if (species != null) {
      this.species = species;
      taxonomySpeciesId = species.id;
    }

    if (description != null) {
      this.description = description;
    }

    viewId = await updateSpecies(viewId,
        description: description, taxonomySpeciesId: taxonomySpeciesId);

    return viewId;
  }
}

class SpeciesPaginator extends Paginator<Species> {
  @override
  DocumentNode nextPageQuery(String? cursor) {
    return gql(allSpeciesQuery(cursor));
  }

  @override
  PaginatedCollection<Species> parseJSON(Map<String, dynamic> json) {
    final list = json[DEFAULT_RESULTS_KEY]['documents'] as List;
    final documents = list
        .map((sighting) => Species.fromJson(sighting as Map<String, dynamic>))
        .toList();

    final endCursor = json[DEFAULT_RESULTS_KEY]['endCursor'] as String?;
    final hasNextPage = json[DEFAULT_RESULTS_KEY]['hasNextPage'] as bool;

    return PaginatedCollection(
        documents: documents, hasNextPage: hasNextPage, endCursor: endCursor);
  }
}

String get speciesFields {
  return '''
    $metaFields
    fields {
      description
      species {
        $taxonomyFields
      }
    }
  ''';
}

String speciesQuery(DocumentId id) {
  const schemaId = SchemaIds.bee_species;
  return '''
    query Species() {
      species: $schemaId(id: "$id") {
        $speciesFields
      }
    }
  ''';
}

String firstSpeciesWithTaxon(DocumentId taxonomySpeciesId) {
  const schemaId = SchemaIds.bee_species;

  return '''
    query AllSpecies {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: 1,
        filter: {
          species: { eq: "$taxonomySpeciesId" },
        },
      ) {
        $paginationFields
        documents {
          $speciesFields
        }
      }
    }
  ''';
}

String allSpeciesQuery(String? cursor) {
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  const schemaId = SchemaIds.bee_species;

  return '''
    query AllSpecies {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: $DEFAULT_PAGE_SIZE,
        $after
      ) {
        $paginationFields
        documents {
          $speciesFields
        }
      }
    }
  ''';
}

Future<DocumentViewId> createSpecies(
    {required DocumentId taxonomySpeciesId, String description = ''}) async {
  List<(String, OperationValue)> fields = [
    ("species", OperationValue.relation(taxonomySpeciesId)),
    ("description", OperationValue.string(description)),
  ];

  return await create(SchemaIds.bee_species, fields);
}

Future<DocumentViewId> updateSpecies(DocumentViewId viewId,
    {DocumentId? taxonomySpeciesId, String? description}) async {
  List<(String, OperationValue)> fields = [];

  if (taxonomySpeciesId != null) {
    fields.add(("species", OperationValue.relation(taxonomySpeciesId)));
  }

  if (description != null) {
    fields.add(("description", OperationValue.string(description)));
  }

  return await update(SchemaIds.bee_species, viewId, fields);
}

Future<DocumentViewId> deleteSpecies(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_species, viewId);
}

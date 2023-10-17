// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/taxonomy_species.dart';

class Species {
  final DocumentId id;
  final TaxonomySpecies species;
  final String description;

  Species({required this.id, required this.species, required this.description});

  factory Species.fromJson(Map<String, dynamic> result) {
    return Species(
        id: result['meta']['documentId'] as DocumentId,
        species: TaxonomySpecies.fromJson(
            result['fields']['species'] as Map<String, dynamic>),
        description: result['fields']['description'] as String);
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

String allSpeciesQuery(String? cursor) {
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  final schemaId = SchemaIds.bee_species;

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

Future<DocumentViewId> createSighting(
    DocumentId taxonomySpeciesId, String description) async {
  List<(String, OperationValue)> fields = [
    ("species", OperationValue.relation(taxonomySpeciesId)),
    ("description", OperationValue.string(description)),
  ];

  return await create(SchemaIds.bee_species, fields);
}

Future<DocumentViewId> updateSpecies(DocumentViewId viewId,
    DocumentId? taxonomySpeciesId, String? description) async {
  List<(String, OperationValue)> fields = [];

  if (taxonomySpeciesId != null) {
    fields.add(("species", OperationValue.relation(taxonomySpeciesId)));
  }

  if (description != null) {
    fields.add(("description", OperationValue.string(description)));
  }

  return await update(SchemaIds.bee_species, viewId, fields);
}

Future<void> deleteSpecies(DocumentViewId viewId) async {
  await delete(SchemaIds.bee_species, viewId);
}

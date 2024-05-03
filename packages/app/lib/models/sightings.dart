// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/blobs.dart';
import 'package:app/models/local_names.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/species.dart';

class Sighting {
  final DocumentId id;
  DocumentViewId viewId;

  DateTime datetime;
  double latitude;
  double longitude;
  List<Blob> images;
  Species? species;
  LocalName? localName;
  String comment;

  Sighting(
      {required this.id,
      required this.viewId,
      required this.datetime,
      required this.latitude,
      required this.longitude,
      required this.images,
      this.species,
      this.localName,
      required this.comment});

  factory Sighting.fromJson(Map<String, dynamic> result) {
    final imageDocuments = result['fields']['images']['documents'] as List;
    List<Blob> images = imageDocuments
        .map((item) => Blob.fromJson(item as Map<String, dynamic>))
        .toList();

    final speciesDocuments = result['fields']['species']['documents'] as List;
    List<Species> species = speciesDocuments
        .map((item) => Species.fromJson(item as Map<String, dynamic>))
        .toList();

    final localNameDocuments =
        result['fields']['local_names']['documents'] as List;
    List<LocalName> localNames = localNameDocuments
        .map((item) => LocalName.fromJson(item as Map<String, dynamic>))
        .toList();

    return Sighting(
        id: result['meta']['documentId'] as DocumentId,
        viewId: result['meta']['viewId'] as DocumentViewId,
        datetime: DateTime.parse(result['fields']['datetime'] as String),
        latitude: result['fields']['latitude'] as double,
        longitude: result['fields']['latitude'] as double,
        comment: result['fields']['comment'] as String,
        images: images,
        species: species.firstOrNull,
        localName: localNames.firstOrNull);
  }

  Future<DocumentViewId> update(
      {DateTime? datetime,
      double? latitude,
      double? longitude,
      String? comment,
      List<Species>? species,
      List<LocalName>? localNames}) async {
    List<DocumentId>? speciesIds;
    if (species != null) {
      speciesIds = species.isEmpty ? [] : [species.first.id];
    }

    List<DocumentId>? localNameIds;
    if (localNames != null) {
      localNameIds = localNames.isEmpty ? [] : [localNames.first.id];
    }

    viewId = await updateSighting(
      viewId,
      datetime: datetime,
      latitude: latitude,
      longitude: longitude,
      comment: comment,
      speciesIds: speciesIds,
      localNameIds: localNameIds,
    );

    if (datetime != null) {
      this.datetime = datetime;
    }

    if (latitude != null) {
      this.latitude = latitude;
    }

    if (longitude != null) {
      this.longitude = longitude;
    }

    if (species != null) {
      this.species = species.firstOrNull;
    }

    if (localNames != null) {
      localName = localNames.firstOrNull;
    }

    return viewId;
  }

  Future<DocumentViewId> delete() async {
    viewId = await deleteSighting(viewId);
    return viewId;
  }
}

class SightingPaginator extends Paginator<Sighting> {
  @override
  DocumentNode nextPageQuery(String? cursor) {
    return gql(allSightingsQuery(cursor));
  }

  @override
  PaginatedCollection<Sighting> parseJSON(Map<String, dynamic> json) {
    final list = json[DEFAULT_RESULTS_KEY]['documents'] as List;
    final documents = list
        .map((sighting) => Sighting.fromJson(sighting as Map<String, dynamic>))
        .toList();

    final endCursor = json[DEFAULT_RESULTS_KEY]['endCursor'] as String?;
    final hasNextPage = json[DEFAULT_RESULTS_KEY]['hasNextPage'] as bool;

    return PaginatedCollection(
        documents: documents, hasNextPage: hasNextPage, endCursor: endCursor);
  }
}

String get sightingFields {
  return '''
    $metaFields
    fields {
      datetime
      latitude
      longitude
      comment
      images {
        documents {
          $blobFields
        }
      }
      species {
        documents {
          $speciesFields
        }
      }
      local_names {
        documents {
          $localNameFields
        }
      }
    }
  ''';
}

String allSightingsQuery(String? cursor) {
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  const schemaId = SchemaIds.bee_sighting;

  return '''
    query AllSightings {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: $DEFAULT_PAGE_SIZE,
        $after
        orderBy: "datetime",
        orderDirection: DESC
      ) {
        $paginationFields
        documents {
          $sightingFields
        }
      }
    }
  ''';
}

String sightingQuery(DocumentId id) {
  const schemaId = SchemaIds.bee_sighting;
  return '''
    query Sighting() {
      sighting: $schemaId(id: "$id") {
        $sightingFields
      }
    }
  ''';
}

String lastSightingQuery(DocumentId speciesId) {
  const schemaId = SchemaIds.bee_sighting;
  return '''
    query LastSighting() {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: 1,
        filter: {
          species: { in: ["$speciesId"] },
        },
        orderBy: "datetime",
        orderDirection: DESC,
      ) {
        documents {
          $sightingFields
        }
      }
    }
  ''';
}

String allSpeciesImages(DocumentId speciesId, String? cursor) {
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  const schemaId = SchemaIds.bee_sighting;

  return '''
    query AllSpeciesImages() {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        first: $DEFAULT_PAGE_SIZE,
        $after
        filter: {
          species: { in: ["$speciesId"] },
        },
        orderBy: "datetime",
        orderDirection: DESC
      ) {
        $paginationFields
        documents {
          images {
            documents {
              $blobFields
            }
          }
        }
      }
    }
  ''';
}

Future<DocumentViewId> createSighting(
    {required DateTime datetime,
    double latitude = 0.0,
    double longitude = 0.0,
    String comment = '',
    List<DocumentId> imageIds = const [],
    List<DocumentId> speciesIds = const [],
    List<DocumentId> localNameIds = const []}) async {
  List<(String, OperationValue)> fields = [
    ("datetime", OperationValue.string(datetime.toIso8601String())),
    ("latitude", OperationValue.float(latitude)),
    ("longitude", OperationValue.float(longitude)),
    ("images", OperationValue.relationList(imageIds)),
    ("species", OperationValue.relationList(speciesIds)),
    ("local_names", OperationValue.relationList(localNameIds)),
    ("comment", OperationValue.string(comment))
  ];

  return await create(SchemaIds.bee_sighting, fields);
}

Future<DocumentViewId> updateSighting(DocumentViewId viewId,
    {DateTime? datetime,
    double? latitude,
    double? longitude,
    String? comment,
    List<DocumentId>? imageIds,
    List<DocumentId>? speciesIds,
    List<DocumentId>? localNameIds}) async {
  List<(String, OperationValue)> fields = [];

  if (datetime != null) {
    fields.add(("datetime", OperationValue.string(datetime.toString())));
  }

  if (latitude != null) {
    fields.add(("latitude", OperationValue.float(latitude)));
  }

  if (longitude != null) {
    fields.add(("longitude", OperationValue.float(longitude)));
  }

  if (imageIds != null) {
    fields.add(("images", OperationValue.relationList(imageIds)));
  }

  if (speciesIds != null) {
    fields.add(("species", OperationValue.relationList(speciesIds)));
  }

  if (localNameIds != null) {
    fields.add(("local_names", OperationValue.relationList(localNameIds)));
  }

  if (comment != null) {
    fields.add(("comment", OperationValue.string(comment)));
  }

  return await update(SchemaIds.bee_sighting, viewId, fields);
}

Future<DocumentViewId> deleteSighting(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_sighting, viewId);
}

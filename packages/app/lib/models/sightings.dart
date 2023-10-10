// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/schema_ids.dart';

class Sighting {
  final String id;
  final DateTime datetime;
  final double latitude;
  final double longitude;
  final List<String> images;
  final String? species;
  final String? local_name;
  final String comment;

  Sighting(
      {required this.id,
      required this.datetime,
      required this.latitude,
      required this.longitude,
      required this.images,
      this.species,
      this.local_name,
      required this.comment});

  factory Sighting.fromJson(Map<String, dynamic> result) {
    final imageDocuments = result['fields']['images']['documents'] as List;
    List<String> imageIds = imageDocuments
        .map((item) => item['meta']['documentId'] as String)
        .toList();

    final speciesDocuments = result['fields']['species']['documents'] as List;
    List<String> speciesNames = speciesDocuments
        .map((item) => item['fields']['name'] as String)
        .toList();

    final localNameDocuments =
        result['fields']['local_names']['documents'] as List;
    List<String> localNames = localNameDocuments
        .map((item) => item['fields']['name'] as String)
        .toList();

    return Sighting(
        id: result['meta']['documentId'] as String,
        datetime: DateTime.parse(result['fields']['datetime'] as String),
        latitude: result['fields']['latitude'] as double,
        longitude: result['fields']['latitude'] as double,
        images: imageIds,
        species: speciesNames.firstOrNull,
        local_name: localNames.firstOrNull,
        comment: result['fields']['comment'] as String);
  }
}

class SightingList {
  final List<Sighting> sightings;

  SightingList({required this.sightings});

  factory SightingList.fromJson(List<dynamic> json) {
    return SightingList(
        sightings: (json)
            .map((sightingJson) =>
                Sighting.fromJson(sightingJson as Map<String, dynamic>))
            .toList());
  }
}

class PaginatedSightingList {
  final List<Sighting> sightings;
  String? endCursor;
  final bool hasNextPage;

  PaginatedSightingList(
      {required this.sightings, this.endCursor, required this.hasNextPage});

  factory PaginatedSightingList.fromJson(Map<String, dynamic> json) {
    final documents = json['documents'] as List;
    List<Sighting> sightingsList = documents
        .map((sighting) => Sighting.fromJson(sighting as Map<String, dynamic>))
        .toList();

    String? endCursor = json['endCursor'] as String?;
    bool hasNextPage = json['hasNextPage'] as bool;

    return PaginatedSightingList(
        sightings: sightingsList,
        endCursor: endCursor,
        hasNextPage: hasNextPage);
  }
}

String allSightingsQuery(String? cursor) {
  String after = (cursor != null) ? '''after: "$cursor",''' : "";

  final schemaId = SchemaIds.bee_sighting;
  return '''
    query AllSightings {
      sightings: all_$schemaId(first: 3, $after orderBy: "datetime", orderDirection: DESC) {
        hasNextPage
        endCursor
        documents {
          meta {
            owner
            documentId
            viewId
          }
          fields {
            datetime
            latitude
            longitude
            images {
              documents {
                meta {
                  documentId
                }
              }
            }
            species {
              documents {
                fields {
                  description
                  species {
                    fields {
                      name
                    }
                  }
                }
              }
            }
            local_names {
              documents {
                fields {
                  name
                }
              }
            }
            comment
          }
        }
      }
    }
  ''';
}

String sightingQuery(String id) {
  final schemaId = SchemaIds.bee_sighting;
  return '''
    query GetSighting() {
      sighting: $schemaId(id: "$id") {
        meta {
          owner
          documentId
          viewId
        }
        fields {
          datetime
          latitude
          longitude
          images {
            documents {
              meta {
                documentId
              }
            }
          }
          species {
            documents {
              fields {
                description
                species {
                  fields {
                    name
                  }
                }
              }
            }
          }
          local_names {
            documents {
              fields {
                name
              }
            }
          }
          comment
        }
      }
    }
  ''';
}

Future<DocumentViewId> createSighting(
    DateTime datetime,
    double latitude,
    double longitude,
    List<String> images,
    String? species,
    String? local_name,
    String comment) async {
  List<(String, OperationValue)> fields = [
    ("datetime", OperationValue.string(datetime.toString())),
    ("latitude", OperationValue.float(latitude)),
    ("longitude", OperationValue.float(longitude)),
    ("images", OperationValue.relationList(images)),
    ("comment", OperationValue.string(comment))
  ];

  if (species != null) {
    fields.add(("species", OperationValue.relationList([species])));
  } else {
    fields.add(("species", OperationValue.relationList([])));
  }

  if (local_name != null) {
    fields.add(("local_names", OperationValue.relationList([local_name])));
  } else {
    fields.add(("local_names", OperationValue.relationList([])));
  }

  // @TODO: Remove this
  print(fields);

  return await create(SchemaIds.bee_sighting, fields);
}

Future<DocumentViewId> updateSighting(
    DocumentViewId viewId,
    DateTime? datetime,
    double? latitude,
    double? longitude,
    List<String>? images,
    String? species,
    String? local_names,
    String? comment) async {
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

  if (images != null) {
    fields.add(("images", OperationValue.relationList(images)));
  }

  if (species != null) {
    fields.add(("species", OperationValue.relationList([species])));
  }

  if (local_names != null) {
    fields.add(("local_names", OperationValue.relationList([local_names])));
  }

  if (comment != null) {
    fields.add(("comment", OperationValue.string(comment)));
  }

  return await update(SchemaIds.bee_sighting, viewId, fields);
}

Future<void> deleteSighting(DocumentViewId viewId) async {
  await delete(SchemaIds.bee_sighting, viewId);
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/schema_ids.dart';

class Sighting {
  final String id;
  final String datetime;
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

  factory Sighting.fromJson(Map<String, dynamic> json) {
    List<String> species_list = json['fields']['species'] as List<String>;
    List<String> local_names_list =
        json['fields']['local_names'] as List<String>;

    return Sighting(
        id: json['meta']['documentId'] as String,
        datetime: json['fields']['datetime'] as String,
        latitude: json['fields']['latitude'] as double,
        longitude: json['fields']['latitude'] as double,
        images: json['fields']['images'] as List<String>,
        species: species_list.firstOrNull,
        local_name: local_names_list.firstOrNull,
        comment: json['fields']['comment'] as String);
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

String get allSightingsQuery {
  final schemaId = SchemaIds.bee_sighting;
  return '''
    query AllSightings() {
      sightings: all_$schemaId(orderBy: "datetime", orderDirection: DESC) {
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
                  name
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
                name
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
    String datetime,
    double latitude,
    double longitude,
    List<String> images,
    String? species,
    String? local_name,
    String comment) async {
  List<(String, OperationValue)> fields = [
    ("datetime", OperationValue.string(datetime)),
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
    fields.add(("local_name", OperationValue.relationList([local_name])));
  } else {
    fields.add(("local_name", OperationValue.relationList([])));
  }

  return await create(SchemaIds.bee_sighting, fields);
}

Future<DocumentViewId> updateSighting(
    DocumentViewId viewId,
    String? datetime,
    double? latitude,
    double? longitude,
    List<String>? images,
    String? species,
    String? local_names,
    String? comment) async {
  List<(String, OperationValue)> fields = [];

  if (datetime != null) {
    fields.add(("datetime", OperationValue.string(datetime)));
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

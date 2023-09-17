// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/schema_ids.dart';

class Sighting {
  final String id;
  final String name;
  final String species;
  final String timestamp;
  final String img;

  Sighting(
      {required this.id,
      required this.name,
      required this.species,
      required this.timestamp,
      required this.img});

  factory Sighting.fromJson(Map<String, dynamic> json) {
    return Sighting(
        id: json['meta']['documentId'] as String,
        name: json['fields']['name'] as String,
        species: 'Melipona',
        timestamp: '01.01.2023',
        img:
            'https://media.npr.org/assets/img/2018/10/30/bee1_wide-1dead2b859ef689811a962ce7aa6ace8a2a733d7-s1200.jpg');
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
  final schemaId = SchemaIds.sightings;
  return '''
    query AllSightings() {
      sightings: all_$schemaId(orderBy: "name", orderDirection: DESC) {
        documents {
          meta {
            owner
            documentId
            viewId
          }
          fields {
            name
          }
        }
      }
    }
  ''';
}

String sightingQuery(String id) {
  final schemaId = SchemaIds.sightings;
  return '''
    query GetSighting() {
      sighting: $schemaId(id: "$id") {
        meta {
          owner
          documentId
          viewId
        }
        fields {
          name
        }
      }
    }
  ''';
}

Future<DocumentViewId> createSighting(String name) async {
  return await create(
      SchemaIds.sightings, [("name", OperationValue.string(name))]);
}

Future<DocumentViewId> updateSighting(
    DocumentViewId viewId, String name) async {
  return await update(
      SchemaIds.sightings, viewId, [("name", OperationValue.string(name))]);
}

Future<void> deleteSighting(DocumentViewId viewId) async {
  await delete(SchemaIds.sightings, viewId);
}

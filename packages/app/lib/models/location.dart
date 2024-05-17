// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

enum LocationType {
  Box,
  Building,
  Ground,
  Tree,
}

/*
 * Generic location methods across all location types
 */

class Location {
  final DocumentId id;
  DocumentViewId viewId;

  final LocationType type;
  final DocumentId sightingId;
  double? height;
  double? diameter;

  Location({
    required this.id,
    required this.viewId,
    required this.type,
    required this.sightingId,
    this.height,
    this.diameter,
  }) {
    if (type == LocationType.Tree) {
      if (height == null || diameter == null) {
        throw "Locations of type 'tree' need a height and diameter value";
      }
    }
  }

  factory Location.fromJson(LocationType type, Map<String, dynamic> result) {
    double? height;
    double? diameter;

    if (type == LocationType.Tree) {
      height = result['fields']['height'] as double;
      diameter = result['fields']['diameter'] as double;
    }

    return Location(
      id: result['meta']['documentId'] as DocumentId,
      viewId: result['meta']['viewId'] as DocumentViewId,
      type: type,
      sightingId:
          result['fields']['sighting']['meta']['documentId'] as DocumentId,
      height: height,
      diameter: diameter,
    );
  }

  static Future<Location> create(
      {required LocationType type,
      required DocumentId sightingId,
      double? height,
      double? diameter}) async {
    DocumentViewId? viewId;

    if (type == LocationType.Tree) {
      viewId = await createLocationTree(
          sightingId: sightingId, height: height!, diameter: diameter!);
    } else if (type == LocationType.Box) {
      viewId = await createLocationBox(sightingId: sightingId);
    } else if (type == LocationType.Ground) {
      viewId = await createLocationGround(sightingId: sightingId);
    } else if (type == LocationType.Building) {
      viewId = await createLocationBuilding(sightingId: sightingId);
    }

    return Location(
      id: viewId!,
      viewId: viewId,
      type: type,
      sightingId: sightingId,
      height: height,
      diameter: diameter,
    );
  }

  Future<DocumentViewId> update({double? height, double? diameter}) async {
    if (type != LocationType.Tree) {
      throw "Can only update locations of type 'tree'";
    }

    viewId =
        await updateLocationTree(viewId, height: height, diameter: diameter);
    return viewId;
  }

  Future<DocumentViewId> delete() async {
    if (type == LocationType.Tree) {
      viewId = await deleteLocationTree(viewId);
    } else if (type == LocationType.Box) {
      viewId = await deleteLocationBox(viewId);
    } else if (type == LocationType.Ground) {
      viewId = await deleteLocationGround(viewId);
    } else if (type == LocationType.Building) {
      viewId = await deleteLocationBuilding(viewId);
    }
    return viewId;
  }
}

String locationQuery(DocumentId sightingId) {
  const locationBoxSchemaId = SchemaIds.bee_attributes_location_box;
  const locationBuildingSchemaId = SchemaIds.bee_attributes_location_building;
  const locationGroundSchemaId = SchemaIds.bee_attributes_location_ground;
  const locationTreeSchemaId = SchemaIds.bee_attributes_location_tree;

  String parameters = '''
    first: 1,
    filter: {
      sighting: { eq: "$sightingId" },
    },
  ''';

  return '''
    query GetAllLocationsForSighting {
      locationBox: all_$locationBoxSchemaId($parameters) {
        documents {
          $locationBoxFields
        }
      }
      locationBuilding: all_$locationBuildingSchemaId($parameters) {
        documents {
          $locationBuildingFields
        }
      }
      locationGround: all_$locationGroundSchemaId($parameters) {
        documents {
          $locationGroundFields
        }
      }
      locationTree: all_$locationTreeSchemaId($parameters) {
        documents {
          $locationTreeFields
        }
      }
    }
  ''';
}

/*
 * Location: Tree
 */

String get locationTreeFields {
  return '''
    $metaFields
    fields {
      height
      diameter
      sighting {
        meta {
          documentId
        }
      }
    }
  ''';
}

String allLocationsTreeQuery(List<DocumentId>? sightingIds, String? cursor) {
  final after = (cursor != null) ? '''after: "$cursor",''' : '';
  String filter = '';
  if (sightingIds != null) {
    String sightingsString = sightingIds.map((id) => '''"$id"''').join(", ");
    filter = '''filter: { sighting: { in: [$sightingsString] } },''';
  }
  const schemaId = SchemaIds.bee_attributes_location_tree;

  return '''
    query AllLocationTree {
      $DEFAULT_RESULTS_KEY: all_$schemaId(
        $filter
        first: $DEFAULT_PAGE_SIZE,
        $after
      ) {
        $paginationFields
        documents {
          $locationTreeFields
        }
      }
    }
  ''';
}

Future<DocumentViewId> createLocationTree(
    {required DocumentId sightingId,
    required double height,
    required double diameter}) async {
  List<(String, OperationValue)> fields = [
    ("sighting", OperationValue.relation(sightingId)),
    ("height", OperationValue.float(height)),
    ("diameter", OperationValue.float(diameter)),
  ];
  return await create(SchemaIds.bee_attributes_location_tree, fields);
}

Future<DocumentViewId> updateLocationTree(DocumentViewId viewId,
    {double? height, double? diameter}) async {
  List<(String, OperationValue)> fields = [];

  if (height != null) {
    fields.add(("height", OperationValue.float(height)));
  }

  if (diameter != null) {
    fields.add(("diameter", OperationValue.float(diameter)));
  }

  return await update(viewId, SchemaIds.bee_attributes_location_tree, fields);
}

Future<DocumentViewId> deleteLocationTree(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_attributes_location_tree, viewId);
}

/*
 * Location: Box
 */

String get locationBoxFields {
  return '''
    $metaFields
    fields {
      sighting {
        meta {
          documentId
        }
      }
    }
  ''';
}

Future<DocumentViewId> createLocationBox({
  required DocumentId sightingId,
}) async {
  List<(String, OperationValue)> fields = [
    ("sighting", OperationValue.relation(sightingId)),
  ];
  return await create(SchemaIds.bee_attributes_location_box, fields);
}

Future<DocumentViewId> deleteLocationBox(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_attributes_location_box, viewId);
}

/*
 * Location: Building
 */

String get locationBuildingFields {
  return '''
    $metaFields
    fields {
      sighting {
        meta {
          documentId
        }
      }
    }
  ''';
}

Future<DocumentViewId> createLocationBuilding({
  required DocumentId sightingId,
}) async {
  List<(String, OperationValue)> fields = [
    ("sighting", OperationValue.relation(sightingId)),
  ];
  return await create(SchemaIds.bee_attributes_location_building, fields);
}

Future<DocumentViewId> deleteLocationBuilding(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_attributes_location_building, viewId);
}

/*
 * Location: Ground
 */

String get locationGroundFields {
  return '''
    $metaFields
    fields {
      sighting {
        meta {
          documentId
        }
      }
    }
  ''';
}

Future<DocumentViewId> createLocationGround({
  required DocumentId sightingId,
}) async {
  List<(String, OperationValue)> fields = [
    ("sighting", OperationValue.relation(sightingId)),
  ];
  return await create(SchemaIds.bee_attributes_location_ground, fields);
}

Future<DocumentViewId> deleteLocationGround(DocumentViewId viewId) async {
  return await delete(SchemaIds.bee_attributes_location_ground, viewId);
}

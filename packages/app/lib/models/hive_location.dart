// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:graphql/client.dart';
import 'package:p2panda/p2panda.dart';

import 'package:app/io/graphql/graphql.dart';
import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/base.dart';
import 'package:app/models/schema_ids.dart';

const BOX_RESULTS_KEY = 'locationBox';
const BUILDING_RESULTS_KEY = 'locationBuilding';
const GROUND_RESULTS_KEY = 'locationGround';
const TREE_RESULTS_KEY = 'locationTree';

enum HiveLocationType {
  Box,
  Building,
  Ground,
  Tree,
}

/*
 * Generic location methods across all location types
 */

class HiveLocation {
  final DocumentId id;
  DocumentViewId viewId;

  final HiveLocationType type;
  final DocumentId sightingId;
  String? treeSpecies;
  double? height;
  double? diameter;

  HiveLocation({
    required this.id,
    required this.viewId,
    required this.type,
    required this.sightingId,
    this.treeSpecies,
    this.height,
    this.diameter,
  });

  factory HiveLocation.fromJson(
      HiveLocationType type, Map<String, dynamic> result) {
    String? treeSpecies;
    double? height;
    double? diameter;

    if (type == HiveLocationType.Tree) {
      // Values are not nullable in p2panda schemas
      treeSpecies = result['fields']['tree_species'] as String;
      height = result['fields']['height'] as double;
      diameter = result['fields']['diameter'] as double;

      // .. so we do that afterwards
      if (treeSpecies.isEmpty) {
        treeSpecies = null;
      }

      if (height == 0.0) {
        height = null;
      }

      if (diameter == 0.0) {
        diameter = null;
      }
    }

    return HiveLocation(
      id: result['meta']['documentId'] as DocumentId,
      viewId: result['meta']['viewId'] as DocumentViewId,
      type: type,
      sightingId:
          result['fields']['sighting']['meta']['documentId'] as DocumentId,
      treeSpecies: treeSpecies,
      height: height,
      diameter: diameter,
    );
  }

  static Future<HiveLocation> create(
      {required HiveLocationType type,
      required DocumentId sightingId,
      String? treeSpecies,
      double? height,
      double? diameter}) async {
    DocumentViewId? viewId;

    if (type == HiveLocationType.Tree) {
      viewId = await createLocationTree(
          sightingId: sightingId,
          treeSpecies: treeSpecies,
          height: height,
          diameter: diameter);
    } else if (type == HiveLocationType.Box) {
      viewId = await createLocationBox(sightingId: sightingId);
    } else if (type == HiveLocationType.Ground) {
      viewId = await createLocationGround(sightingId: sightingId);
    } else if (type == HiveLocationType.Building) {
      viewId = await createLocationBuilding(sightingId: sightingId);
    }

    return HiveLocation(
      id: viewId!,
      viewId: viewId,
      type: type,
      sightingId: sightingId,
      treeSpecies: treeSpecies,
      height: height,
      diameter: diameter,
    );
  }

  Future<DocumentViewId> update(
      {String? treeSpecies, double? height, double? diameter}) async {
    if (type != HiveLocationType.Tree) {
      throw "Can only update locations of type 'tree'";
    }

    viewId = await updateLocationTree(viewId,
        treeSpecies: treeSpecies, height: height, diameter: diameter);

    if (treeSpecies != null) {
      this.treeSpecies = treeSpecies.isEmpty ? null : treeSpecies;
    }

    if (height != null) {
      this.height = height == 0.0 ? null : height;
    }

    if (diameter != null) {
      this.diameter = diameter == 0.0 ? null : diameter;
    }

    return viewId;
  }

  Future<DocumentViewId> delete() async {
    if (type == HiveLocationType.Tree) {
      viewId = await deleteLocationTree(viewId);
    } else if (type == HiveLocationType.Box) {
      viewId = await deleteLocationBox(viewId);
    } else if (type == HiveLocationType.Ground) {
      viewId = await deleteLocationGround(viewId);
    } else if (type == HiveLocationType.Building) {
      viewId = await deleteLocationBuilding(viewId);
    }

    // Remove any other hive location as well, just to make sure we're cleaning
    // up after ourselves
    await deleteAllLocations(sightingId);

    return viewId;
  }
}

String locationQuery(List<DocumentId> sightingIds) {
  const locationBoxSchemaId = SchemaIds.bee_attributes_location_box;
  const locationBuildingSchemaId = SchemaIds.bee_attributes_location_building;
  const locationGroundSchemaId = SchemaIds.bee_attributes_location_ground;
  const locationTreeSchemaId = SchemaIds.bee_attributes_location_tree;

  String sightingsString = sightingIds.map((id) => '''"$id"''').join(", ");
  String parameters = '''
    filter: {
      sighting: { in: [$sightingsString] },
    },
  ''';

  // Our data-model allows attaching multiple locations to a sighting, but in
  // our UI we're only displaying one of them. This query checks for all
  // location types first and we handle selecting one later
  return '''
    query GetLocationForSighting {
      $BOX_RESULTS_KEY: all_$locationBoxSchemaId($parameters) {
        documents {
          $locationBoxFields
        }
      }
      $BUILDING_RESULTS_KEY: all_$locationBuildingSchemaId($parameters) {
        documents {
          $locationBuildingFields
        }
      }
      $GROUND_RESULTS_KEY: all_$locationGroundSchemaId($parameters) {
        documents {
          $locationGroundFields
        }
      }
      $TREE_RESULTS_KEY: all_$locationTreeSchemaId($parameters) {
        documents {
          $locationTreeFields
        }
      }
    }
  ''';
}

/// Deletes all hive locations which are associated with a sighting.
///
/// Even though we're only displaying _one_ hive location per sighting it might
/// be possible that others exist. To make sure we're cleaning up after ourselves
/// this method deletes _all known_ hive locations to that sighting.
Future<void> deleteAllLocations(DocumentId sightingId) async {
  final result = await client
      .query(QueryOptions(document: gql(locationQuery([sightingId]))));

  if (result.hasException) {
    throw "Deleting all hive locations related to sighting failed: ${result.exception}";
  }

  List<HiveLocation> locations =
      getAllLocationsFromResult(result.data as Map<String, dynamic>);

  for (var location in locations) {
    await location.delete();
  }
}

/// Returns one hive location for a sighting if it exists.
///
/// Expects multiple results from a multi-query GraphQL request over all
/// location types. This method will automatically select one of them based
/// on deterministic rules as the UI can only display one location at a time
/// for sightings.
HiveLocation? getLocationFromResults(Map<String, dynamic> result) {
  var boxLocations = result[BOX_RESULTS_KEY]['documents'] as List;
  var buildingLocations = result[BUILDING_RESULTS_KEY]['documents'] as List;
  var groundLocations = result[GROUND_RESULTS_KEY]['documents'] as List;
  var treeLocations = result[TREE_RESULTS_KEY]['documents'] as List;

  if (boxLocations.isNotEmpty) {
    return HiveLocation.fromJson(
        HiveLocationType.Box, boxLocations[0] as Map<String, dynamic>);
  }

  if (buildingLocations.isNotEmpty) {
    return HiveLocation.fromJson(HiveLocationType.Building,
        buildingLocations[0] as Map<String, dynamic>);
  }

  if (groundLocations.isNotEmpty) {
    return HiveLocation.fromJson(
        HiveLocationType.Ground, groundLocations[0] as Map<String, dynamic>);
  }

  if (treeLocations.isNotEmpty) {
    return HiveLocation.fromJson(
        HiveLocationType.Tree, treeLocations[0] as Map<String, dynamic>);
  }

  return null;
}

List<HiveLocation> getAllLocationsFromResult(Map<String, dynamic> result) {
  List<HiveLocation> list = [];

  for (var item in result[BOX_RESULTS_KEY]['documents'] as List) {
    list.add(HiveLocation.fromJson(
        HiveLocationType.Box, item as Map<String, dynamic>));
  }

  for (var item in result[BUILDING_RESULTS_KEY]['documents'] as List) {
    list.add(HiveLocation.fromJson(
        HiveLocationType.Building, item as Map<String, dynamic>));
  }

  for (var item in result[GROUND_RESULTS_KEY]['documents'] as List) {
    list.add(HiveLocation.fromJson(
        HiveLocationType.Ground, item as Map<String, dynamic>));
  }

  for (var item in result[TREE_RESULTS_KEY]['documents'] as List) {
    list.add(HiveLocation.fromJson(
        HiveLocationType.Tree, item as Map<String, dynamic>));
  }

  return list;
}

class AggregatedHiveLocations {
  int boxCounter = 0;
  int buildingCounter = 0;
  int groundCounter = 0;
  int treeCounter = 0;
  List<String> treeSpecies = [];
  double treeAverageHeights = 0.0;
  double treeMinHeight = 0.0;
  double treeMaxHeight = 0.0;
  double treeAverageDiameters = 0.0;
  double treeMinDiameter = 0.0;
  double treeMaxDiameter = 0.0;
}

Future<AggregatedHiveLocations> getAggregatedHiveLocations(
    DocumentId speciesId) async {
  // Get all sightings related to species first
  final jsonDocuments = await paginateOverEverything(
      SchemaIds.bee_sighting, "meta { documentId }",
      filter: 'species: { in: ["$speciesId"] }');

  List<DocumentId> sightingIds = [];
  for (var json in jsonDocuments) {
    sightingIds.add(json['meta']['documentId'] as DocumentId);
  }

  // Get all hive locations from all these sightings
  final response = await client
      .query(QueryOptions(document: gql(locationQuery(sightingIds))));

  if (response.hasException) {
    throw response.exception!;
  }

  final hiveLocations =
      getAllLocationsFromResult(response.data as Map<String, dynamic>);

  // Derive aggregated informations
  var aggregated = AggregatedHiveLocations();
  double heightSum = 0.0;
  double diameterSum = 0.0;
  int heightDataPointsNum = 0;
  int diameterDataPointsNum = 0;

  for (var location in hiveLocations) {
    if (location.type == HiveLocationType.Box) {
      aggregated.boxCounter += 1;
    } else if (location.type == HiveLocationType.Building) {
      aggregated.buildingCounter += 1;
    } else if (location.type == HiveLocationType.Ground) {
      aggregated.groundCounter += 1;
    } else if (location.type == HiveLocationType.Tree) {
      aggregated.treeCounter += 1;

      if (location.diameter != null && location.diameter! > 0.0) {
        diameterSum += location.diameter!;
        diameterDataPointsNum += 1;

        if (location.diameter! > aggregated.treeMaxDiameter) {
          aggregated.treeMaxDiameter = location.diameter!;
        }

        if (location.diameter! < aggregated.treeMinDiameter) {
          aggregated.treeMinDiameter = location.diameter!;
        }
      }

      if (location.height != null && location.height! > 0.0) {
        heightSum += location.height!;
        heightDataPointsNum += 1;

        if (location.height! > aggregated.treeMaxHeight) {
          aggregated.treeMaxHeight = location.height!;
        }

        if (location.height! < aggregated.treeMinHeight) {
          aggregated.treeMinHeight = location.height!;
        }
      }

      if (location.treeSpecies != null &&
          location.treeSpecies!.isNotEmpty &&
          !aggregated.treeSpecies.contains(location.treeSpecies)) {
        aggregated.treeSpecies.add(location.treeSpecies!);
      }
    }
  }

  aggregated.treeAverageDiameters = diameterSum / diameterDataPointsNum;
  aggregated.treeAverageHeights = heightSum / heightDataPointsNum;

  return aggregated;
}

/*
 * Location: Tree
 */

String get locationTreeFields {
  return '''
    $metaFields
    fields {
      tree_species
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

Future<DocumentViewId> createLocationTree(
    {required DocumentId sightingId,
    String? treeSpecies,
    double? height,
    double? diameter}) async {
  List<(String, OperationValue)> fields = [
    ("tree_species", OperationValue.string(treeSpecies ?? "")),
    ("height", OperationValue.float(height ?? 0.0)),
    ("diameter", OperationValue.float(diameter ?? 0.0)),
    ("sighting", OperationValue.relation(sightingId)),
  ];
  return await create(SchemaIds.bee_attributes_location_tree, fields);
}

Future<DocumentViewId> updateLocationTree(DocumentViewId viewId,
    {String? treeSpecies, double? height, double? diameter}) async {
  List<(String, OperationValue)> fields = [];

  if (treeSpecies != null) {
    fields.add(("tree_species", OperationValue.string(treeSpecies)));
  }

  if (height != null) {
    fields.add(("height", OperationValue.float(height)));
  }

  if (diameter != null) {
    fields.add(("diameter", OperationValue.float(diameter)));
  }

  return await update(SchemaIds.bee_attributes_location_tree, viewId, fields);
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

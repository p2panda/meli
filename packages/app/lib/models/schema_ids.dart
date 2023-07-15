// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/io/p2panda/schemas.dart';

/// Schema ids used by the meli app.
abstract final class SchemaIds {
  /// Sightings schema.
  static const SchemaId sightings =
      'sightings_002081af7cc57386e83eb22c9c2380d9945446a0e61f82e57e27c2f5a0ddf2a00312';
}

/// List of all schema ids which are used by the meli app.
const List<SchemaId> ALL_SCHEMA_IDS = [
  SchemaIds.sightings,
];

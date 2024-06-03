// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/app.dart';
import 'package:app/io/p2panda/node.dart';
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/io/p2panda/seed.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/router.dart';

void main() async {
  // Start application
  runApp(const MeliApp());

  // Bootstrap backend for p2p communication and data persistence
  await bootstrapNode();

  // Go to main screen
  router.go(RoutePaths.allSightings.path);
}

Future<void> bootstrapNode() async {
  // Run p2panda node in the background
  await startNode();

  // Migrate pending p2panda schemas if necessary
  final bool didMigrate = await migrateSchemas();
  if (didMigrate) {
    print("Migration succeeded");
  } else {
    print("No migration required");
  }

  // Wait until we're sure that all schema ids are ready on the node. This is
  // mostly important after a migration took place
  await untilSchemasAvailable(ALL_SCHEMA_IDS);

  // Seed database with initial data when necessary
  final bool didSeed = await seedDatabase();
  if (didSeed) {
    print("Seed succeeded");
  } else {
    print("No seed required");
  }
}

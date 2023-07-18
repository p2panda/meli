// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:app/app.dart';
import 'package:app/io/p2panda/node.dart';
import 'package:app/io/p2panda/schemas.dart';
import 'package:app/models/schema_ids.dart';

void main() async {
  // Wait until we've established connection to native Flutter backend. We need
  // to call this when we want to run native code before we call `runApp`
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep native splash screen up until app has finished bootstrapping
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Start application
  runApp(MeliApp());

  // Bootstrap backend for p2p communication and data persistence
  await bootstrapNode();

  // Go to main screen
  router.go(RoutePath.allSightings);

  // Remove splash screen when bootstrap is complete
  FlutterNativeSplash.remove();
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
}

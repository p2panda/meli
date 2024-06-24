// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/io/files.dart';
import 'package:app/io/graphql/queries.dart';
import 'package:app/io/p2panda/key_pair.dart';
import 'package:app/io/p2panda/p2panda.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/utils/sleep.dart';

const List<String> relayAddresses = (bool.hasEnvironment("RELAY_ADDRESS") &&
        String.fromEnvironment("RELAY_ADDRESS") != "")
    ? [String.fromEnvironment("RELAY_ADDRESS")]
    : [];

const String logLevel =
    String.fromEnvironment("LOG_LEVEL", defaultValue: "ERROR");

/// Start a p2panda node in the background.
Future<void> startNode() async {
  // Determine folder where we can persist data
  final basePath = await applicationSupportDirectory;

  // Set up SQLite database file inside of persisted phone directory
  final databaseUrl = 'sqlite:/$basePath/db.sqlite3';

  // Re-use client's key pair also for node. Note that during networking the
  // peer id will be a hashed version of the public key and it will not leak
  final key = await keyPair;

  // Start node in background thread
  p2panda.startNode(
    logLevel: logLevel,
    keyPair: key,
    databaseUrl: databaseUrl,
    blobsBasePath: basePath,
    relayAddresses: relayAddresses,
    allowSchemaIds: ALL_SCHEMA_IDS,
  );

  p2panda.subscribeLogStream().listen((logEntry) {
    print(logEntry.msg);
  });

  // .. since we can't `await` the FFI binding method from Rust we need to
  // poll here to find out until the node is ready
  await _untilReady();
}

/// Shut down p2panda node.
Future<void> shutdownNode() async {
  await p2panda.shutdownNode();
}

/// Async helper method to block until node is up and running.
Future<void> _untilReady() async {
  final publicKey = await publicKeyHex;

  while (true) {
    try {
      // Send a simple GraphQL request to find out if node responds
      await nextArgs(publicKey, null);

      // If we got a response (no exception) we can stop here
      break;
    } catch (err) {
      // Ignore thrown exceptions and keep on trying again after a while
      await sleep(250);
    }
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:typed_data';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:toml/toml.dart';
import 'package:convert/convert.dart';

import 'package:app/io/assets.dart';
import 'package:app/io/graphql/graphql.dart';
import 'package:app/io/graphql/queries.dart' as queries;
import 'package:app/io/p2panda/p2panda.dart';
import 'package:app/utils/sleep.dart';

/// Path to .toml file holding all data for schema migrations.
const String MIGRATION_FILE_PATH = 'assets/schema.lock';

/// p2panda schema identifier represented as a string.
typedef SchemaId = String;

/// Checks for pending migrations of p2panda schemas and automatically deploys
/// them on the node.
///
/// This is especially useful for first-start runtimes which need to establish
/// all schemas first before we can create data based on them.
///
/// For convenience this method takes its migration data from a `schema.lock`
/// file which was generated with the `fishy` tool. To update the schemas one
/// needs to just check update this file with `fishy`, this method will do the
/// rest.
Future<bool> migrateSchemas() async {
  // Load .toml file holding the migration data which was generated with
  // p2panda `fishy` tool
  final toml = await loadAsset(MIGRATION_FILE_PATH);
  final migration = await TomlDocument.parse(toml).toMap();
  final commits = migration['commits'] as List<dynamic>;
  return await publishCommits(commits);
}

Future<bool> publishCommits(List<dynamic> commits) async {
  // Flag to indicate if any publishing took place
  bool didPublish = false;

  // Iterate over all commits which are required to migrate to the latest
  // version. This loop automatically checks if the commit already took place
  // and ignores them if so
  for (var commit in commits) {
    // Decode entry from commit to retrieve public key, sequence number and log
    // id from it
    final Uint8List entryBytes =
    hex.decode(commit['entry'] as String) as Uint8List;
    final entry = await p2panda.decodeEntry(entry: entryBytes);
    String publicKey = entry.$1;
    BigInt logId = BigInt.parse(entry.$2);
    BigInt seqNum = BigInt.parse(entry.$3);

    try {
      // Check if node already knows about this entry
      final nextArgs =
      await queries.nextArgs(publicKey, commit['entry_hash'] as String);

      if (logId != nextArgs.logId) {
        throw Exception('Critical log id mismatch during migration');
      }

      // Entry already exists, we can ignore this commit
      if (seqNum < nextArgs.seqNum) {
        continue;
      }
    } catch (err) {
      // Ignore when query fails, it might happen when the entry was not
      // published yet
    }

    // Publish commit to node, this will materialize the (updated) schema on
    // the node and give us a new GraphQL API
    await queries.publish(
        commit['entry'] as String, commit['operation'] as String);
    didPublish = true;
  }

  return didPublish;
}

/// Returns true if schema is materialized and ready on node.
Future<bool> isSchemaAvailable(SchemaId schemaId) async {
  String query = '''
    query CheckSchemaStatus() {
      status: all_$schemaId {
        documents {
          meta {
            documentId
          }
        }
      }
    }
  ''';

  final options = QueryOptions(document: gql(query));
  final result = await client.query(options);
  return !result.hasException;
}

/// Async helper method to block until node materialized schemas and updated
/// GraphQL API.
Future<void> untilSchemasAvailable(List<SchemaId> schemaIds) async {
  // Iterate over all required schema ids and check if they already exist
  Future<bool> areAllSchemasAvailable() async {
    for (var schemaId in schemaIds) {
      if (!(await isSchemaAvailable(schemaId))) {
        return false;
      }
    }

    return true;
  }

  // .. do this until all of them exist
  while (true) {
    if (await areAllSchemasAvailable()) {
      break;
    } else {
      sleep(250);
    }
  }
}

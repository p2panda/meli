import 'dart:typed_data';

import 'package:app/io/p2panda/publish.dart';
import 'package:toml/toml.dart';
import 'package:convert/convert.dart';

import 'package:app/io/p2panda/p2panda.dart';
import 'package:app/io/graphql/queries.dart' as queries;
import 'package:app/io/assets.dart';

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
  // Flag to indicate if any migrations took place
  bool didMigrate = false;

  // Load .toml file holding the migration data which was generated with
  // p2panda `fishy` tool
  final toml = await loadAsset(MIGRATION_FILE_PATH);
  final migration = await TomlDocument.parse(toml).toMap();
  final commits = migration['commits'] as List<dynamic>;

  // Iterate over all commits which are required to migrate to the latest
  // schemas. This loop automatically checks if the commit already took place
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

    // Check if node already knows about this entry
    try {
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
    await publishRaw(commit['entry'] as String, commit['operation'] as String);
    didMigrate = true;
  }

  return didMigrate;
}
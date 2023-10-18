// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:toml/toml.dart';

import 'package:app/io/assets.dart';
import 'package:app/io/p2panda/schemas.dart';

/// Path to .toml file holding all data for database seeds.
const String SEED_FILE_PATH = 'assets/seed.lock';

Future<bool> seedDatabase() async {
  // Load .toml file holding the migration data which was generated with
  // p2panda `fishy` tool
  final toml = await loadAsset(SEED_FILE_PATH);
  final migration = await TomlDocument.parse(toml).toMap();
  final commits = migration['commits'] as List<dynamic>;
  return await publishCommits(commits);
}

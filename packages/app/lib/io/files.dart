// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:path_provider/path_provider.dart' as provider;

/// Blobs base path.
const String BLOBS_BASE_PATH = 'http://localhost:2020/blobs';

Future<String> get applicationSupportDirectory async {
  final directory = await provider.getApplicationSupportDirectory();
  return directory.path;
}

Future<String> get temporaryDirectory async {
  final directory = await provider.getTemporaryDirectory();
  return directory.path;
}

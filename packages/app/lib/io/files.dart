// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as provider;

/// Blobs base path.
const String BLOBS_BASE_PATH = 'http://localhost:2020/blobs';

Future<String> get applicationSupportDirectory async {
  final directory = await provider.getApplicationSupportDirectory();
  return directory.path;
}

Future<void> downloadAndExportImages(
    List<String> blobIds, String targetDirectory) async {
  for (var id in blobIds) {
    final http.Response response =
        await http.get(Uri.parse("$BLOBS_BASE_PATH/$id"));
    final file = File("$targetDirectory/$id.jpg");
    await file.writeAsBytes(response.bodyBytes);
  }
}

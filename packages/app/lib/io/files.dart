// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:path_provider/path_provider.dart' as provider;

Future<String> get applicationSupportDirectory async {
  final directory = await provider.getApplicationSupportDirectory();
  return directory.path;
}

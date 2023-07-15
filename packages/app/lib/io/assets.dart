// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

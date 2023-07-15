import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

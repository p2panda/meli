import 'package:path_provider/path_provider.dart' as provider;

Future<String> get applicationSupportDirectory async {
  final directory = await provider.getApplicationSupportDirectory();
  return directory.path;
}
/// Runs a dummy async task for a defined amount of time.
Future<void> sleep(int milliseconds) async {
  return Future.delayed(Duration(milliseconds: milliseconds));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:app/app.dart';

void main() async {
  // Wait until we've established connection to native Flutter backend. We need
  // to call this when we want to run native code before we call `runApp`
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep native splash screen up until app has finished bootstrapping
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Start application
  runApp(MeliApp());

  // Bootstrap backend for p2p communication and data persistence
  // @TODO

  // Remove splash screen when bootstrap is complete
  FlutterNativeSplash.remove();
}
import 'package:p2panda/src/bridge_generated.dart';

/// Represents the external library for p2panda
///
/// Will be a DynamicLibrary for dart:io or WasmModule for dart:html
typedef ExternalLibrary = Object;

P2Panda createWrapperImpl(ExternalLibrary lib) => throw UnimplementedError();

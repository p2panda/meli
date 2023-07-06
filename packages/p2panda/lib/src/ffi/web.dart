import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:p2panda/src/bridge_generated.dart';

typedef ExternalLibrary = WasmModule;

P2Panda createWrapperImpl(ExternalLibrary module) => P2PandaImpl.wasm(module);

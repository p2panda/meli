import 'dart:ffi';

import 'package:p2panda/src/bridge_generated.dart';

typedef ExternalLibrary = DynamicLibrary;

P2Panda createWrapperImpl(ExternalLibrary dylib) => P2PandaImpl(dylib);

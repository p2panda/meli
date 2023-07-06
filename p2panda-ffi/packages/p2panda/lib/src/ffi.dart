import 'package:p2panda/src/bridge_generated.dart';
import 'package:p2panda/src/ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

P2Panda? _wrapper;

P2Panda createWrapper(ExternalLibrary lib) {
  _wrapper ??= createWrapperImpl(lib);
  return _wrapper!;
}

import 'bridge_generated.dart';
import 'stub.dart'
    if (dart.library.io) 'io.dart'
    if (dart.library.html) 'web.dart';

P2Panda? _wrapper;

P2Panda createWrapper(ExternalLibrary lib) {
  _wrapper ??= createWrapperImpl(lib);
  return _wrapper!;
}

import 'package:p2panda/p2panda.dart';
import 'ffi/stub.dart'
    if (dart.library.io) 'ffi/io.dart'
    if (dart.library.html) 'ffi/web.dart';

P2Panda createLib() =>
    createWrapper(createLibraryImpl());

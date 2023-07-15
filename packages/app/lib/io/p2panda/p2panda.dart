// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda_flutter/p2panda_flutter.dart';

/// Create p2panda library originating from Rust API via FFI bindings.
///
/// The APIs coming out of this are undogmatic for Dart and look sometimes a bit
/// strange. With wrapper methods in this module we try to make them slightly
/// more ergonomic.
final P2Panda p2panda = createLib();

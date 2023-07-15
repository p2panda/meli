// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:p2panda_flutter/p2panda_flutter.dart';
import 'package:path/path.dart' as path;

import 'package:app/io/files.dart';
import 'package:app/io/p2panda/p2panda.dart';

/// File where private key is stored.
const String PRIVATE_KEY_FILE_NAME = 'private.key';

/// Singleton workaround to only load / generate key pair once per runtime.
KeyPair? _keyPairSingleton;

/// Getter to receive an Ed25519 key pair.
///
/// If no key pair exists yet, it will automatically be generated and stored to
/// the Android file system.
Future<KeyPair> get keyPair async {
  if (_keyPairSingleton != null) {
    return _keyPairSingleton!;
  }

  // Determine folder to load private key file from
  final basePath = await applicationSupportDirectory;
  final filePath = await path.join(basePath, PRIVATE_KEY_FILE_NAME);

  final io.File file = io.File(filePath);

  // Load private key from existing file or generate a new one
  if (file.existsSync()) {
    final bytes = await file.readAsBytes();
    _keyPairSingleton =
        await p2panda.fromPrivateKeyStaticMethodKeyPair(bytes: bytes);
  } else {
    _keyPairSingleton = await p2panda.newStaticMethodKeyPair();
    final bytes = await _keyPairSingleton!.privateKey();
    await file.writeAsBytes(bytes);
  }

  return _keyPairSingleton!;
}

/// Returns public key as bytes.
Future<Uint8List> get publicKey async {
  final _keyPair = await keyPair;
  return await _keyPair.publicKey();
}

/// Returns public key encoded as hexadecimal string.
Future<String> get publicKeyHex async {
  final _publicKey = await publicKey;
  return hex.encode(_publicKey);
}

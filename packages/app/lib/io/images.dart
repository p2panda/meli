// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

import 'package:app/io/files.dart';

const IMAGE_QUALITY = 80;
const IMAGE_MAX_WIDTH = 1920;
const IMAGE_MAX_HEIGHT = 1080;

Future<File> removeExifAndCompress(File file) async {
  final temporaryDirPath = await temporaryDirectory;
  final uuid = const Uuid().v1().toString();

  final result = await FlutterImageCompress.compressAndGetFile(
    file.path,
    "$temporaryDirPath/$uuid.jpg",
    quality: IMAGE_QUALITY,
    minWidth: IMAGE_MAX_WIDTH,
    minHeight: IMAGE_MAX_HEIGHT,
    keepExif: false,
    format: CompressFormat.jpeg,
  );

  if (result == null) {
    throw "Processing image failed ${file.path}";
  }

  return File(result.path);
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:p2panda/p2panda.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/schema_ids.dart';
import 'package:app/models/base.dart';

const MAX_BLOB_PIECE_LENGTH = 256;

class Blob {
  final String id;

  Blob({required this.id});

  factory Blob.fromJson(Map<String, dynamic> result) {
    return Blob(id: result['meta']['documentId'] as String);
  }
}

String get blobFields {
  return '''
    $metaFields
  ''';
}

Future<DocumentViewId> publishBlob(File file) async {
  // Check the mimetype.
  final mimeType = lookupMimeType(file.path);

  // Open a reader onto the blob file.
  final reader = await file.open(mode: FileMode.read);

  // Get the length and calculate the total number of pieces, based on the
  // maximum allowed piece size.
  final length = await reader.length();
  final expected_pieces = (length / MAX_BLOB_PIECE_LENGTH).ceil();

  // This is where we will keep ids of the created blob pieces
  List<DocumentViewId> blob_pieces = [];

  // For each expected piece read the chunk of bytes into a buffer and publish
  // the piece to the node.
  for (var i = 0; i < expected_pieces; i++) {
    // Calculate the offset we want to start reading from.
    int offset = i * MAX_BLOB_PIECE_LENGTH;

    // Set the read position based on current offset.
    RandomAccessFile rangeReader = await reader.setPosition(offset);

    // Populate a fixed buffer which will contain the bytes of a single blob
    // piece. Account for the final blob piece being variable length.
    Uint8List buffer;
    if (blob_pieces.length == expected_pieces - 1) {
      buffer = Uint8List(length - offset);
    } else {
      buffer = Uint8List(MAX_BLOB_PIECE_LENGTH);
    }

    // Create and publish the blob piece and store it's id for use later.
    await rangeReader.readInto(buffer);
    DocumentViewId id = await createBlobPiece(buffer);
    blob_pieces.add(id);
  }

  // Close the reader.
  await reader.close();

  // Now create and publish the blob.
  return await createBlob(mimeType.toString(), length, blob_pieces);
}

Future<DocumentViewId> createBlobPiece(Uint8List bytes) async {
  List<(String, OperationValue)> fields = [
    ("data", OperationValue.bytes(bytes)),
  ];
  return await create(SchemaIds.blob_piece, fields);
}

Future<DocumentViewId> createBlob(
    String mimeType, int length, List<DocumentViewId> pieces) async {
  List<(String, OperationValue)> fields = [
    ("mime_type", OperationValue.string(mimeType)),
    ("length", OperationValue.integer(length)),
    ("pieces", OperationValue.pinnedRelationList(pieces)),
  ];
  return await create(SchemaIds.blob, fields);
}

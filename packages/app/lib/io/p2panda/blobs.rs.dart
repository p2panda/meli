// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';
import 'dart:typed_data';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/schema_ids.dart';
import 'package:p2panda/p2panda.dart';

const MAX_BLOB_PIECE_LENGTH = 256;

Future<DocumentViewId> publishBlob(File file) async {
  // TODO: Check mimetype

  // Open a reader onto the blob file.
  final reader = await file.open(mode: FileMode.read);

  // Get the length and calculate the total number of pieces, based on the
  // maximum allowed pieces size.
  final length = await reader.length();
  final expected_pieces = (length / MAX_BLOB_PIECE_LENGTH).ceil();

  // This is where we will keep ids of the created blob pieces
  List<DocumentViewId> blob_pieces = [];

  // For each expected piece read each chunk of bytes into a buffer and publish
  // the piece to the node.
  for (var i = 0; i < expected_pieces; i++) {
    // Calculate the offset we want to start reading from.
    int offset = i * MAX_BLOB_PIECE_LENGTH;

    // Populate a fixed length buffer from the reader starting from the offset
    // position.
    Uint8List buffer = Uint8List(MAX_BLOB_PIECE_LENGTH);
    int bytesRead = await reader.readInto(buffer, offset);

    // In case this is the last iteration, trim the final piece to the number of
    // bytes read.
    buffer.removeRange(bytesRead, MAX_BLOB_PIECE_LENGTH);

    // Create and publish the blob piece and store it's id for use later.
    DocumentViewId id = await createBlobPiece(buffer);
    blob_pieces.add(id);
  }
  await reader.close();

  // Now create and publish the blob.
  return await createBlob('image/jpeg', length, blob_pieces);
}

Future<DocumentViewId> createBlobPiece(Uint8List bytes) async {
  List<(String, OperationValue)> fields = [
    ("bytes", OperationValue.bytes(bytes)),
  ];
  return await create(SchemaIds.blob_piece, fields);
}

Future<DocumentViewId> createBlob(
    String mimeType, int length, List<DocumentViewId> pieces) async {
  List<(String, OperationValue)> fields = [
    ("mimetype", OperationValue.string(mimeType)),
    ("length", OperationValue.integer(length)),
    ("mimetype", OperationValue.pinnedRelationList(pieces)),
  ];
  return await create(SchemaIds.blob, fields);
}

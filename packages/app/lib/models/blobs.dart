// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/base.dart';

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

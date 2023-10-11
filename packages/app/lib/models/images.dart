// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/base.dart';

class Image {
  final String id;

  Image({required this.id});

  factory Image.fromJson(Map<String, dynamic> result) {
    return Image(id: result['meta']['documentId'] as String);
  }
}

String get imageFields {
  return '''
    $metaFields
  ''';
}

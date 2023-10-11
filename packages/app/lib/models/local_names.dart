// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/base.dart';

class LocalName {
  final String id;
  final String name;

  LocalName({required this.id, required this.name});

  factory LocalName.fromJson(Map<String, dynamic> result) {
    return LocalName(
        id: result['meta']['documentId'] as String,
        name: result['fields']['name'] as String);
  }
}

String get localNameFields {
  return '''
    $metaFields
    fields {
      name
    }
  ''';
}

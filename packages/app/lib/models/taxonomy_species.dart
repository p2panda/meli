// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/models/base.dart';

class TaxonomySpecies {
  final String id;
  final String name;

  TaxonomySpecies({required this.id, required this.name});

  factory TaxonomySpecies.fromJson(Map<String, dynamic> result) {
    return TaxonomySpecies(
        id: result['meta']['documentId'] as String,
        name: result['fields']['name'] as String);
  }
}

String get taxonomySpeciesFields {
  return '''
    $metaFields
    fields {
      name
    }
  ''';
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:p2panda_flutter/p2panda_flutter.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/schema_ids.dart';

Future<DocumentViewId> createSighting(String name) async {
  return await create(
      SchemaIds.sightings, [("name", OperationValue.string(name))]);
}

Future<DocumentViewId> updateSighting(
    DocumentViewId viewId, String name) async {
  return await update(
      SchemaIds.sightings, viewId, [("name", OperationValue.string(name))]);
}

Future<void> deleteSighting(DocumentViewId viewId) async {
  await delete(SchemaIds.sightings, viewId);
}

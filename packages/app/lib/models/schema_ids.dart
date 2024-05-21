// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/io/p2panda/schemas.dart';

/// Schema ids used by the meli app.
abstract final class SchemaIds {
  /// System schema
  static const SchemaId blob_piece = 'blob_piece_v1';
  static const SchemaId blob = 'blob_v1';

  /// Sighting and species schema.
  static const SchemaId bee_sighting =
      'bee_sighting_0020df662f01bd4eed879ebb2128edd3e0b55902f179eeaf8978e58011f96b488717';
  static const SchemaId bee_local_name =
      'bee_local_name_0020aeaca910c8a3f5fb0f80f7e8e6878720272d3bdcefa45c97cfc627e3b5e4252c';
  static const SchemaId bee_species =
      'bee_species_00207889f44a73c94bb9f7e7d087e47d87ab4854c3693bca35bf16c596c8c91c5fe7';

  /// Bee attributes schema.
  static const SchemaId bee_attributes_location_tree =
      'bee_attributes_location_tree_0020a960a5e60c7daf66f9b9056de6e7904247360017dd09c223800e65223c0adafe';
  static const SchemaId bee_attributes_location_ground =
      'bee_attributes_location_ground_00207f1b4d7115e518ed754024db27c86756479c9448aebc3f39a0e67c18b611bc25';
  static const SchemaId bee_attributes_location_building =
      'bee_attributes_location_building_002021849ffe9546354fab1c421a6e5f5aaa49ae6d1bddffbe057444f67ba6e4743f';
  static const SchemaId bee_attributes_location_box =
      'bee_attributes_location_box_00202a2f65b79de2f10a03fbd2adeeea491bfb36dd86998af86f8335414a654dbde0';
  static const SchemaId bee_attributes_used_for =
      'bee_attributes_used_for_002064feb6c43eca60974c8f5e60475b1b931cdc920e8441bd4c88f280a0b2f0cedc';

  /// Taxonomy schema.
  static const SchemaId taxonomy_kingdom =
      'taxonomy_kingdom_0020f3cd78f31cd41fb554d605b11b8facdccba5d93322376ba988a4fee4d7893f43';
  static const SchemaId taxonomy_phylum =
      'taxonomy_phylum_002098b9c13e1162b360a528196c4293ed1e00e71359048323e9af2929ddf1e30313';
  static const SchemaId taxonomy_class =
      'taxonomy_class_0020c790691e036ed090392b4c06eb3586eb130edaee6ece2d4a48607f240bc11f91';
  static const SchemaId taxonomy_order =
      'taxonomy_order_00208ced5b9fc23a3f3e87444c4be7f305bbfcf4989d77cf6d208c579de1fe0a3b79';
  static const SchemaId taxonomy_family =
      'taxonomy_family_0020bdb78e578befd97784e2ec7710f5314fc22fb484e59eef7a66f948ea953a38dc';
  static const SchemaId taxonomy_subfamily =
      'taxonomy_subfamily_0020abf0e567ec55d407c288f7d77bd58f1a529fdb0eb6cbb74279b83b53fb4fa9c2';
  static const SchemaId taxonomy_tribe =
      'taxonomy_tribe_0020eff38ee4ed5bed12b61452c6472f8cd9c692e4f39b36a6b35f16fde309d56d00';
  static const SchemaId taxonomy_genus =
      'taxonomy_genus_0020ebf2746448b4fdf563de1486efc082c1243522d2579aeaaf12e7937c6bc86eba';
  static const SchemaId taxonomy_species =
      'taxonomy_species_0020e1567cb6f7e097b449cd05174f96ac17f774d8b80ffea423c4d4b386e423cb0a';
}

/// List of all schema ids which are used by the meli app.
const List<SchemaId> ALL_SCHEMA_IDS = [
  SchemaIds.bee_sighting,
  SchemaIds.bee_local_name,
  SchemaIds.bee_species,
  SchemaIds.bee_attributes_location_tree,
  SchemaIds.bee_attributes_location_ground,
  SchemaIds.bee_attributes_location_building,
  SchemaIds.bee_attributes_location_box,
  SchemaIds.bee_attributes_used_for,
  SchemaIds.taxonomy_kingdom,
  SchemaIds.taxonomy_phylum,
  SchemaIds.taxonomy_class,
  SchemaIds.taxonomy_order,
  SchemaIds.taxonomy_family,
  SchemaIds.taxonomy_subfamily,
  SchemaIds.taxonomy_tribe,
  SchemaIds.taxonomy_genus,
  SchemaIds.taxonomy_species,
];

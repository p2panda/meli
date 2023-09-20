// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/io/p2panda/schemas.dart';

/// Schema ids used by the meli app.
abstract final class SchemaIds {
  /// Sighting schema.
  static const SchemaId meli_sighting =
      'meli_sighting_0020a84f751ffb3c2d3690d2a1cde853505ca1bf7c92c3aa7f807330a032e36cabdd';
  static const SchemaId meli_sighting_species =
      'meli_sighting_species_00201d4ebf6464024a85ca9bdbaa05631755f6f3ad697d324e1a915bb1cb635df15a';

  /// Species schema.
  static const SchemaId meli_species =
      'meli_species_0020888a6482080bbfd0130ab4fbbe899db2f25d83d6324ed1c049866cabcecfcc87';
  static const SchemaId meli_local_name =
      'meli_local_name_00209d88ef8ed780eabcfbb8198aeaffea6945510cc305afa8751bf57b4769a7b79c';

  /// Meli attributes schema.
  static const SchemaId meli_attributes_location_tree =
      'meli_attributes_location_tree_00205aac7316b3206fee6b3984b82146108b62ca6ed20922d9eacd766d1a5a2a63c9';
  static const SchemaId meli_attributes_location_ground =
      'meli_attributes_location_ground_0020d9632431bb68cbd01b6f55672346d7d6c75e04af7ff700aabbcd92fb1e68c93f';
  static const SchemaId meli_attributes_location_building =
      'meli_attributes_location_building_00203c185e59e59f0c551fa770904043cbe33caf12d669b773733ecbea004508b6e8';
  static const SchemaId meli_attributes_location_box =
      'meli_attributes_location_box_00202224257c5524b44c939e2a82af1de54edd26eaa52a5dbf8399e880f4a97b2ec6';
  static const SchemaId meli_attributes_used_for =
      'meli_attributes_used_for_0020abfbe46e69cdc15ac68f50bfb46dac8e9ddc26ae92c48ea27ffc18f8f0c574bf';

  /// Taxonomy schema.
  static const SchemaId taxonomy_kingdom =
      'taxonomy_kingdom_00204396e665a96afcbef5cd3cd87babadd647ce65a6ad543c725ecc9ecb0a941dc8';
  static const SchemaId taxonomy_phylum =
      'taxonomy_phylum_00205063692cfe2adcd3fe5462686513ab82481c62428ae1af32c33b69545e45a5a5';
  static const SchemaId taxonomy_class =
      'taxonomy_class_00207d2f642dafda066d632b7f57b63d23afd4e870e38232fc5da964564e876f4a5b';
  static const SchemaId taxonomy_order =
      'taxonomy_order_0020e10395284ab88ae5599bda2f278a0e562334a2a84a8a82e48b552f347d2d1be4';
  static const SchemaId taxonomy_family =
      'taxonomy_family_0020c19907f238ca92e045c2cc5445ccaaf43c2b2a244276b5f4e3de72e74f9ee0c1';
  static const SchemaId taxonomy_subfamily =
      'taxonomy_subfamily_002091b7017280f9e59471c63f775ce08f8d78cc1f014f1fbbde896438641c6d5e26';
  static const SchemaId taxonomy_tribe =
      'taxonomy_tribe_0020172cfaeeda3371de0e237d5202d82ea20abcd1a712e821825aa23a599fe5b16c';
  static const SchemaId taxonomy_genus =
      'taxonomy_genus_0020229eeb50b4a6092f5c2e42a3a7bbaadad63dea3ec3d9618e1552a4318ababa6e';
  static const SchemaId taxonomy_species =
      'taxonomy_species_002026ba2daee99a70bc66fa93cbde2732fbe8484634fd6557de457741b8cd813686';
}

/// List of all schema ids which are used by the meli app.
const List<SchemaId> ALL_SCHEMA_IDS = [
  SchemaIds.meli_sighting,
  SchemaIds.meli_sighting_species,
  SchemaIds.meli_species,
  SchemaIds.meli_local_name,
  SchemaIds.meli_attributes_location_tree,
  SchemaIds.meli_attributes_location_ground,
  SchemaIds.meli_attributes_location_building,
  SchemaIds.meli_attributes_location_box,
  SchemaIds.meli_attributes_used_for,
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

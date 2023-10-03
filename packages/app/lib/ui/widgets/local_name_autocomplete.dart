// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/autocomplete.dart';

class LocalNameAutocomplete extends StatefulWidget {
  @override
  State<LocalNameAutocomplete> createState() => _LocalNameAutocompleteState();
}

class _LocalNameAutocompleteState extends State<LocalNameAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MeliAutocomplete(onOptionsRequest: (String value) async {
      // @TODO: Make the actual GraphQL request
      final Iterable<String> options = ['dummy', 'data'];
      return options;
    });
  }
}

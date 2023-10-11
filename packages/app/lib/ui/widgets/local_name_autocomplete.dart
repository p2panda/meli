// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/autocomplete.dart';

typedef OnChanged = void Function(String);

class LocalNameAutocomplete extends StatefulWidget {
  final OnChanged onChanged;

  LocalNameAutocomplete({super.key, required this.onChanged});

  @override
  State<LocalNameAutocomplete> createState() => _LocalNameAutocompleteState();
}

class _LocalNameAutocompleteState extends State<LocalNameAutocomplete> {
  @override
  Widget build(BuildContext context) {
    return MeliAutocomplete(
        onChanged: widget.onChanged,
        onOptionsRequest: (String value) async {
          // @TODO: Make the actual GraphQL request
          final Iterable<String> options = [
            'here',
            'we',
            'have',
            'some',
            'test',
            'data'
          ];
          return options;
        });
  }
}

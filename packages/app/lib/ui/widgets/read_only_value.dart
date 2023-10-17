// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class ReadOnlyValue extends StatelessWidget {
  final String? value;

  const ReadOnlyValue(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    final noValueGivenSymbol =
        (['🤷', '🤷🏻', '🤷🏼', '🤷🏽', '🤷🏾', '🤷🏿']..shuffle()).first;

    return Container(
      alignment: Alignment.center,
      height: 48.0,
      child: Text(value == null ? noValueGivenSymbol : value!,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: value == null ? 35.0 : 16.0,
              shadows: value == null ? [Shadow(blurRadius: 1.0)] : null)),
    );
  }
}

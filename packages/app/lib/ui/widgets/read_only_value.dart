// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

typedef ReadOnlyBuilder<T> = Widget Function(T value);

class ReadOnlyBase<T> extends StatelessWidget {
  final T? value;
  final ReadOnlyBuilder<T> builder;

  const ReadOnlyBase({super.key, required this.value, required this.builder});

  @override
  Widget build(BuildContext context) {
    final noValueGivenSymbol =
        (['🤷', '🤷🏻', '🤷🏼', '🤷🏽', '🤷🏾', '🤷🏿']..shuffle()).first;

    return Container(
      alignment: Alignment.center,
      height: 48.0,
      child: value == null
          ? Text(
              noValueGivenSymbol,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 35.0, shadows: [Shadow(blurRadius: 1.0)]),
            )
          : builder(value as T),
    );
  }
}

class ReadOnlyValue extends StatelessWidget {
  final String? value;

  const ReadOnlyValue(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return ReadOnlyBase<String>(
        value: value,
        builder: (String str) {
          return Text(
            str,
            textAlign: TextAlign.left,
            style: const TextStyle(fontSize: 16.0),
          );
        });
  }
}

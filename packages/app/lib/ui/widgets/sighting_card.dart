// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class SightingCard extends StatefulWidget {
  final String name;

  SightingCard({super.key, required this.name});

  @override
  State<SightingCard> createState() => _SightingCardState();
}

class _SightingCardState extends State<SightingCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(this.widget.name)));
  }
}

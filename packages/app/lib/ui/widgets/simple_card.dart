// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/card_header.dart';
import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';

class SimpleCard extends StatelessWidget {
  final Widget child;
  final String title;

  const SimpleCard({super.key, required this.child, required this.title});

  Widget _content() {
    return Column(
      children: [
        MeliCardHeader(title: title),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
            child: child),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(child: _content());
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/card_header.dart';
import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';

class SimpleCard extends StatelessWidget {
  final Widget child;
  final String title;

  SimpleCard({super.key, required this.child, required this.title});

  Widget _content() {
    return Column(
      children: [
        MeliCardHeader(title: this.title),
        this.child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(child: this._content());
  }
}

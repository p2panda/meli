import 'package:flutter/material.dart';

import 'card.dart';

class ExpansionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const ExpansionCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MeliCard(
          child: ExpansionTile(
        title: Text('hello'),
        subtitle: Text('my subtitle'),
        children: [Text('child one'), Text('child two')],
      )),
    );
  }
}

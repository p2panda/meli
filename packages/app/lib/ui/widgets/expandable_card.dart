import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';

class ExpandableCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const ExpandableCard(
      {super.key, required this.title, this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return MeliCard(
        expandable: true, title: this.title, children: this.children);
  }
}

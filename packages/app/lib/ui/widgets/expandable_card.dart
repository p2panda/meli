// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:app/ui/widgets/expansion_tile.dart';

class ExpandableCard extends StatefulWidget {
  final String title;
  final Widget child;

  const ExpandableCard({super.key, required this.title, required this.child});

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  final GlobalKey<MeliExpansionTileState> tileKey = GlobalKey();

  Widget _icon() {
    final icon = this.isExpanded ? Icon(Icons.remove) : Icon(Icons.add);
    return CardActionButton(
        icon: icon,
        onPressed: () {
          this.tileKey.currentState!.toggle();
        });
  }

  Widget _content() {
    return MeliExpansionTile(
      key: tileKey,
      header: MeliCardHeader(title: widget.title, icon: this._icon()),
      child: widget.child,
      onExpansionChanged: (isExpanded) {
        setState(() {
          this.isExpanded = isExpanded;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(child: this._content());
  }
}

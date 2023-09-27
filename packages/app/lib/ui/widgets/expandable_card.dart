// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/card_action_button.dart';
import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/expansion_tile.dart';

const _borderSide = BorderSide(
  width: 6.0,
  strokeAlign: BorderSide.strokeAlignCenter,
  color: MeliColors.pink,
);
const _borderRadius = BorderRadius.all(Radius.circular(12.0));

class ExpandableCard extends StatefulWidget {
  final String title;
  final Widget child;

  const ExpandableCard({super.key, required this.title, required this.child});

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.fromBorderSide(_borderSide),
          borderRadius: _borderRadius),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          this._title(),
          this._icon(),
        ]),
      ),
    );
  }

  Widget _title() {
    return Text(
      widget.title,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _icon() {
    final icon = this.isExpanded ? Icon(Icons.remove) : Icon(Icons.add);
    return CardActionButton(icon: icon);
  }

  Widget _content() {
    return MeliExpansionTile(
      header: this._header(),
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
    return Card(
        elevation: 5.0,
        color: MeliColors.pink,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: _borderSide,
          borderRadius: _borderRadius,
        ),
        child: this._content());
  }
}

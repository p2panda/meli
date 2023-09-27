import 'package:flutter/material.dart';

import 'package:app/ui/widgets/card.dart';

class MeliCardHeader extends StatelessWidget {
  final String title;
  final Widget? icon;

  MeliCardHeader({super.key, required this.title, this.icon});

  Widget _title() {
    return Text(
      this.title,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _icon() {
    return this.icon != null ? this.icon! : SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.fromBorderSide(borderSide),
          borderRadius: borderRadius),
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.symmetric(
            vertical: this.icon != null ? 9.0 : 14.0, horizontal: 16.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          this._title(),
          this._icon(),
        ]),
      ),
    );
  }
}

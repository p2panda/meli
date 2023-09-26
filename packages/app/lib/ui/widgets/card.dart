// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/expansion_tile.dart';

class MeliCard extends StatelessWidget {
  final List<Widget> children;
  final String? title;
  final String? subtitle;
  final String? footer;
  final Widget? icon;
  final bool expandable;

  MeliCard(
      {super.key,
      required this.children,
      this.title,
      this.subtitle,
      this.footer,
      this.icon,
      this.expandable = false});

  Widget _header() {
    if (this.title != null) {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
            width: double.infinity,
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 4, child: this._title()),
                      Expanded(flex: 1, child: this._icon())
                    ]),
                this._subtitle()
              ],
            ),
          ));
    }

    return SizedBox(height: 0.0);
  }

  Widget _footer() {
    if (this.footer != null) {
      return Container(
        padding: const EdgeInsets.all(10),
        alignment: AlignmentDirectional.center,
        child: Text(
          this.footer.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    return SizedBox(height: 0.0);
  }

  Widget _title() {
    if (this.title != null) {
      return Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          this.title.toString(),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return SizedBox(height: 0.0);
  }

  Widget _icon() {
    if (this.icon != null) {
      return Container(
        alignment: AlignmentDirectional.centerEnd,
        child: this.icon!,
      );
    }

    return SizedBox(height: 0.0);
  }

  Widget _subtitle() {
    if (this.subtitle != null) {
      return Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          this.subtitle.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return SizedBox(height: 0.0);
  }

  Widget _content() {
    if (this.expandable) {
      return ExpansionTileItem(
        isHasTopBorder: false,
        isHasBottomBorder: false,
        isHasLeftBorder: false,
        isHasRightBorder: false,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        isHasTrailing: false,
        tilePadding: EdgeInsets.all(0.0),
        childrenPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        title: this._header(),
        children: this.children,
      );
    }

    return Column(children: [
      this._header(),
      Column(children: this.children),
      this._footer()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5.0,
        color: MeliColors.peach,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 5.0,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: MeliColors.peach,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: this._content());
  }
}

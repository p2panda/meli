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
              border: Border.fromBorderSide(
                BorderSide(
                  width: 6.0,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: MeliColors.peach,
                ),
              ),
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

    return SizedBox.shrink();
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

    return SizedBox.shrink();
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

    return SizedBox.shrink();
  }

  Widget _icon() {
    if (this.icon != null) {
      return Container(
        alignment: AlignmentDirectional.centerEnd,
        child: this.icon!,
      );
    }

    return SizedBox.shrink();
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

    return SizedBox.shrink();
  }

  Widget _content() {
    if (this.expandable) {
      return MeliExpansionTile(
        header: this._header(),
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
            width: 6.0,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: MeliColors.peach,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: this._content());
  }
}

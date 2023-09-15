// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/colors.dart';

class MeliCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final String? footer;
  final Widget? icon;

  MeliCard(
      {super.key,
      required this.child,
      this.title,
      this.subtitle,
      this.footer,
      this.icon});

  Widget _header() {
    if (this.title != null) {
      return Card(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.all(10),
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
            fontSize: 16,
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
            fontSize: 20,
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: MeliColors.magnolia,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 5,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: MeliColors.magnolia,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(children: [this._header(), this.child, this._footer()]),
      ),
    );
  }
}

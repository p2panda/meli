// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/colors.dart';

class MeliCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;

  MeliCard({super.key, required this.child, this.title, this.subtitle});

  Widget _header() {
    if (this.title != null) {
      return Card(
          child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [this._title(), this._subtitle()],
        ),
      ));
    }

    return SizedBox(height: 0.0);
  }

  Widget _title() {
    if (this.title != null) {
      return Container(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          this.title.toString(),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
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
          textAlign: TextAlign.left,
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
        padding: const EdgeInsets.all(1),
        child: Column(children: [this._header(), this.child]),
      ),
    );
  }
}

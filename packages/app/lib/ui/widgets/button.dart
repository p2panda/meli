// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class MeliButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  MeliButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 2.0,
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white),
        onPressed: this.onPressed,
        child: this.child);
  }
}

class MeliIconButton extends MeliButton {
  final Widget icon;

  MeliIconButton({
    super.key,
    required this.icon,
    required super.child,
    super.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          elevation: 2.0,
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white),
      onPressed: this.onPressed,
      icon: this.icon,
      label: this.child,
    );
  }
}

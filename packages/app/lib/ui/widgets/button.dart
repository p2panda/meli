// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class MeliButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const MeliButton({
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
        onPressed: onPressed,
        child: child);
  }
}

class MeliIconButton extends MeliButton {
  final Widget icon;

  const MeliIconButton({
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
      onPressed: onPressed,
      icon: icon,
      label: child,
    );
  }
}

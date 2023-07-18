// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

class MeliFloatingActionButton extends StatefulWidget {
  final Icon icon;
  final String heroTag;
  final VoidCallback onPressed;

  MeliFloatingActionButton(
      {super.key,
      required this.heroTag,
      required this.icon,
      required this.onPressed});

  @override
  State<MeliFloatingActionButton> createState() =>
      _MeliFloatingActionButtonState();
}

class _MeliFloatingActionButtonState extends State<MeliFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.black,
      heroTag: widget.heroTag,
      child: widget.icon,
      shape: const CircleBorder(),
      onPressed: widget.onPressed,
    );
  }
}

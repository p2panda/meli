// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class MeliFloatingActionButton extends StatefulWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final bool disabled;

  const MeliFloatingActionButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.disabled = false,
      this.backgroundColor = MeliColors.magnolia});

  @override
  State<MeliFloatingActionButton> createState() =>
      _MeliFloatingActionButtonState();
}

class _MeliFloatingActionButtonState extends State<MeliFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
        foregroundColor: MeliColors.black,
        backgroundColor:
            widget.disabled ? Colors.grey[400] : widget.backgroundColor,
        heroTag: null,
        shape: const CircleBorder(),
        onPressed: widget.disabled ? null : widget.onPressed,
        child: widget.icon,
      ),
    );
  }
}

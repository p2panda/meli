// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class CardActionButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;

  CardActionButton({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
        elevation: 5.0,
        heroTag: null,
        child: this.icon,
        onPressed: this.onPressed,
        backgroundColor: MeliColors.pink);
  }
}

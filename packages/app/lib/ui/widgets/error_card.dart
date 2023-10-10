// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/icon_message_card.dart';
import 'package:app/ui/colors.dart';

class ErrorCard extends StatelessWidget {
  final String message;

  ErrorCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return IconMessageCard(
      color: MeliColors.peach,
      message: this.message,
      icon: Icons.warning_rounded,
    );
  }
}

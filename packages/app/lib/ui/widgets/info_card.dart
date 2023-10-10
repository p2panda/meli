// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/icon_message_card.dart';

class InfoCard extends StatelessWidget {
  final String message;

  InfoCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return IconMessageCard(
      color: MeliColors.white,
      message: this.message,
      icon: Icons.flare,
    );
  }
}

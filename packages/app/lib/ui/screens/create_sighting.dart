// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/sighting_form.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/widgets/scaffold.dart';

class CreateSightingScreen extends StatefulWidget {
  CreateSightingScreen({super.key});

  @override
  State<CreateSightingScreen> createState() => _CreateSightingScreenState();
}

class _CreateSightingScreenState extends State<CreateSightingScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Create Species',
        body: Container(
            padding: EdgeInsets.all(10.0), child: CreateSightingForm()));
  }
}

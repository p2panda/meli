// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:app/ui/widgets/scaffold.dart';

class SightingScreen extends StatefulWidget {
  SightingScreen({super.key});

  @override
  State<SightingScreen> createState() => _SightingScreenState();
}

class _SightingScreenState extends State<SightingScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'New Sighting',
        body: Container(padding: EdgeInsets.all(10.0), child: Text('Hello')));
  }
}

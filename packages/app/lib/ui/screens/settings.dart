// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/simple_card.dart';
import 'package:flutter/material.dart';

import 'package:app/ui/widgets/expandable_card.dart';
import 'package:app/ui/widgets/scaffold.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Settings',
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: SettingsList()),
        ));
  }
}

class SettingsList extends StatelessWidget {
  final List<Widget> menuListItems = [
    ExpandableCard(
      title: 'Language',
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('portuguese'), Text('english')]),
    ),
    ExpandableCard(
      title: 'Advanced Settings',
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Don\'t click here'),
        Text('Don\'t click here either!')
      ]),
    ),
    ExpandableCard(
      title: 'System Information',
      child: Text('...'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 0.0, runSpacing: 20.0, children: menuListItems);
  }
}

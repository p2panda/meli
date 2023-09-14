// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/card.dart';

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
    MeliCard(
        child: ExpansionTile(
      title: Text('Language'),
      subtitle: Text('language settings'),
      children: [Text('portuguese'), Text('english')],
    )),
    MeliCard(
        child: ExpansionTile(
      title: Text('Advanced Settings'),
      subtitle: Text('warning! There be dragons...'),
      children: [Text('don\'t touch'), Text('don\'t touch here either')],
    )),
    MeliCard(
        child: ExpansionTile(
      title: Text('System Information'),
      subtitle: Text('check out information about this device'),
      children: [Text('......')],
    ))
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: menuListItems);
  }
}

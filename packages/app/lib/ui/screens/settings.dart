// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:app/ui/widgets/expandable_card.dart';
import 'package:app/ui/widgets/scaffold.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo? _deviceData;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final deviceData = await deviceInfoPlugin.androidInfo;

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Settings',
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Wrap(spacing: 0.0, runSpacing: 20.0, children: [
                ExpandableCard(
                  title: 'Language',
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('portuguese'), Text('english')]),
                ),
                ExpandableCard(
                  title: 'Advanced Settings',
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Don\'t click here'),
                        Text('Don\'t click here either!')
                      ]),
                ),
                ExpandableCard(
                  title: 'System Information',
                  child: Text(_deviceData.toString()),
                ),
              ])),
        ));
  }
}

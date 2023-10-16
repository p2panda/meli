// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:app/app.dart';
import 'package:app/ui/colors.dart';
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
    final t = AppLocalizations.of(context)!;

    return MeliScaffold(
        title: t.settings,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Wrap(runSpacing: 20.0, children: [
                LocaleSettings(),
                SystemInfo(),
              ])),
        ));
  }
}

class LocaleSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context)!;

    return ExpandableCard(
        title: t.settingsLanguages,
        child: DropdownMenu<Locale>(
            initialSelection: currentLocale,
            onSelected: (Locale? value) {
              final app = context.findAncestorStateOfType<MeliAppState>()!;
              app.changeLocale(value!);
            },
            dropdownMenuEntries: [
              DropdownMenuEntry<Locale>(
                  value: Locale('en'), label: t.settingsEnglish),
              DropdownMenuEntry<Locale>(
                  value: Locale('pt'), label: t.settingsPortuguese)
            ]));
  }
}

class SystemInfo extends StatefulWidget {
  @override
  State<SystemInfo> createState() => _SystemInfoState();
}

class _SystemInfoState extends State<SystemInfo> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<AndroidDeviceInfo> get _getSystemInfo async {
    return await deviceInfoPlugin.androidInfo;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ExpandableCard(
      title: t.settingsSystemInformation,
      child: FutureBuilder<AndroidDeviceInfo>(
          future: _getSystemInfo,
          builder: (BuildContext context,
              AsyncSnapshot<AndroidDeviceInfo> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Device: ${snapshot.data!.device}'),
                  Text('Android SDK Version: ${snapshot.data!.version.sdkInt}'),
                  Text(
                      'Android Build Version: ${snapshot.data!.version.release}'),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(
                  'Something went wrong, could not retrieve system information');
            } else {
              return Container(
                padding: const EdgeInsets.all(20.0),
                child: const Center(
                    child: CircularProgressIndicator(color: MeliColors.black)),
              );
            }
          }),
    );
  }
}

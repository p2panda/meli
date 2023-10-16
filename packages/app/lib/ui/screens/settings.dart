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
        backgroundColor: MeliColors.sky,
        body: Container(
          decoration: new PandaBackground(),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.0, bottom: 20.0),
              child: Wrap(runSpacing: 20.0, children: [
                HelloPanda(),
                LocaleSettings(),
                SystemInfo(),
              ])),
        ));
  }
}

class HelloPanda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('🐼', style: TextStyle(fontSize: 60.0)));
  }
}

class LocaleSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context)!;

    return ExpandableCard(
        title: t.settingsLanguages,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return DropdownMenu<Locale>(
                width: constraints.maxWidth,
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
                ]);
          },
        ));
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

class PandaBackground extends Decoration {
  PandaBackground();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _PandaPainter();
  }
}

class _PandaPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size? bounds = configuration.size;

    final paint = Paint()
      ..color = MeliColors.flurry
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(bounds!.width, 0);
    path.lineTo(bounds!.width / 2, 75.0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path.shift(offset), paint);
  }
}

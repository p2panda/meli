// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/app.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/expandable_card.dart';
import 'package:app/ui/widgets/scaffold.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

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
          decoration: const PandaBackground(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: const SingleChildScrollView(
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
  const HelloPanda({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('🐼', style: TextStyle(fontSize: 60.0)));
  }
}

class LocaleSettings extends StatelessWidget {
  const LocaleSettings({super.key});

  Future<void> _onLanguageChange(
      BuildContext context, String? languageCode) async {
    final app = context.findAncestorStateOfType<MeliAppState>()!;
    final t = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    bool success = await app.changeLocale(languageCode!);

    if (success) {
      messenger.showSnackBar(SnackBar(content: Builder(builder: (context) {
        return Text(AppLocalizations.of(context)!
            .settingsLanguageChangeSuccess(languageCode));
      })));
    } else {
      messenger.showSnackBar(SnackBar(
        content: Text(t.settingsLanguageChangeError),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final t = AppLocalizations.of(context)!;

    return ExpandableCard(
        title: t.settingsLanguages,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return DropdownMenu<String>(
                inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10.0)),
                width: constraints.maxWidth,
                menuStyle: const MenuStyle(
                    elevation: WidgetStatePropertyAll<double>(3.0),
                    surfaceTintColor:
                        WidgetStatePropertyAll<Color>(Colors.transparent),
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(MeliColors.white),
                    side: WidgetStatePropertyAll<BorderSide>(
                        BorderSide(width: 0))),
                initialSelection: currentLocale.languageCode,
                onSelected: (String? locale) async {
                  await _onLanguageChange(context, locale);
                },
                dropdownMenuEntries: [
                  DropdownMenuEntry<String>(
                      value: 'en', label: t.settingsEnglish),
                  DropdownMenuEntry<String>(
                      value: 'pt', label: t.settingsPortuguese)
                ]);
          },
        ));
  }
}

class SystemInfo extends StatefulWidget {
  const SystemInfo({super.key});

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
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${t.settingsSystemInfoDevice}: ${snapshot.data!.device}'),
                    Text(
                        '${t.settingsSystemInfoSDK}: ${snapshot.data!.version.sdkInt}'),
                    Text(
                        '${t.settingsSystemInfoAndroid}: ${snapshot.data!.version.release}'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text(t.settingsSystemInfoError);
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
  const PandaBackground();

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
    path.lineTo(bounds.width / 2, 75.0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path.shift(offset), paint);
  }
}

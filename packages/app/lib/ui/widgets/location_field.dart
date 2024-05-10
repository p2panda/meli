// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:math';

import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef OnUpdate = void Function(
    {required double latitude, required double longitude});

class LocationField extends StatefulWidget {
  final double latitude;
  final double longitude;

  final OnUpdate onUpdate;

  const LocationField(
      {super.key,
      required this.longitude,
      required this.latitude,
      required this.onUpdate});

  @override
  State<LocationField> createState() => _LocationFieldState();
}

enum InputMode { read, edit }

class _LocationFieldState extends State<LocationField> {
  InputMode _inputMode = InputMode.read;

  late double _lat;
  late double _lon;

  @override
  void initState() {
    _lat = widget.latitude;
    _lon = widget.longitude;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MeliCard(
        child: Column(
      children: [
        MeliCardHeader(
            title: t.sightingLocationFieldTitle,
            icon: _inputMode == InputMode.read
                ? CardActionButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: _handleStartEditMode)
                : null),
        Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _renderMap(),
                Text(t.sightingLocationFieldCoordinates(_lat, _lon),
                    style: const TextStyle(
                      fontSize: 16.0,
                    )),
                if (_inputMode == InputMode.edit) ...[
                  const SizedBox(height: 12),
                  Row(children: [
                    OverflowBar(
                      spacing: 12,
                      overflowAlignment: OverflowBarAlignment.start,
                      children: [
                        FilledButton(
                            onPressed: _handleSave,
                            child: Text(
                              t.sightingLocationFieldSave,
                            )),
                        OutlinedButton(
                            onPressed: _handleCancel,
                            child: Text(
                              t.sightingLocationFieldCancel,
                            ))
                      ],
                    )
                  ])
                ]
              ],
            ))
      ],
    ));
  }

  Widget _renderMap() {
    // TODO: replace with actual map
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: _inputMode == InputMode.read
          ? const Text("🚧 There should be a map here 🚧")
          : OutlinedButton(
              onPressed: () {
                final r = Random();

                double newLat = r.nextInt(181).toDouble();
                double newLon = r.nextInt(91).toDouble();

                setState(() {
                  _lon = newLon;
                  _lat = newLat;
                });
              },
              child: const Text("Simulate location change")),
    );
  }

  void _handleSave() {
    // Do nothing if coordinates have not changed at all
    if (_lat == widget.latitude && _lon == widget.longitude) {
      _handleCancel();
      return;
    }

    setState(() {
      _inputMode = InputMode.read;
      widget.onUpdate(latitude: _lat, longitude: _lon);
    });
  }

  void _handleCancel() {
    setState(() {
      _inputMode = InputMode.read;

      // Reset coordinates to initial values
      _lat = widget.latitude;
      _lon = widget.longitude;
    });
  }

  void _handleStartEditMode() {
    setState(() {
      _inputMode = InputMode.edit;
    });
  }
}

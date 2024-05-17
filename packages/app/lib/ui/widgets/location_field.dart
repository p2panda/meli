// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/widgets/card_action_button.dart';
import 'package:app/ui/widgets/card_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

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

double DEFAULT_ZOOM = 10;
String CURRENT_FEATURE_ID = 'current';
String TARGET_FEATURE_ID = 'target';

class _LocationFieldState extends State<LocationField> {
  InputMode _inputMode = InputMode.read;

  late double _lat;
  late double _lon;

  MaplibreMapController? _mapController;
  Circle? _currentMapMarker;

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
                const SizedBox(
                  height: 20,
                ),
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
    bool enableInteractions = _inputMode == InputMode.edit;

    return Container(
        alignment: Alignment.center,
        height: 200,
        child: MaplibreMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: DEFAULT_ZOOM),
            scrollGesturesEnabled: enableInteractions,
            dragEnabled: enableInteractions,
            zoomGesturesEnabled: enableInteractions,
            trackCameraPosition: enableInteractions,
            compassEnabled: false,
            rotateGesturesEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer()),
            },
            onStyleLoadedCallback: () async {
              _currentMapMarker = await _mapController!.addCircle(CircleOptions(
                  circleRadius: 8,
                  circleColor: Colors.blue.toHexStringRGB(),
                  geometry: LatLng(widget.latitude, widget.longitude)));
            },
            onMapClick: (_, latLng) async {
              if (_inputMode == InputMode.read) return;
              if (_currentMapMarker == null) return;

              var existingNextMarker = _mapController!.circles.where((c) {
                return c != _currentMapMarker;
              }).firstOrNull;

              if (existingNextMarker == null) {
                await _mapController!.addCircle(CircleOptions(
                    circleRadius: 8,
                    circleColor: Colors.blue.toHexStringRGB(),
                    geometry: LatLng(latLng.latitude, latLng.longitude)));

                await _mapController!.updateCircle(_currentMapMarker!,
                    const CircleOptions(circleOpacity: 0.4));
              } else {
                await _mapController!.updateCircle(
                    existingNextMarker, CircleOptions(geometry: latLng));
              }

              _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));

              setState(() {
                _lon = latLng.longitude;
                _lat = latLng.latitude;
              });
            }));
  }

  void _handleSave() async {
    // Do nothing if coordinates have not changed at all
    if (_lat == widget.latitude && _lon == widget.longitude) {
      _handleCancel();
      return;
    }

    setState(() {
      _inputMode = InputMode.read;
      widget.onUpdate(latitude: _lat, longitude: _lon);
    });

    _resetMap(LatLng(_lat, _lon));
  }

  void _handleCancel() async {
    await _resetMap(LatLng(widget.latitude, widget.longitude));

    setState(() {
      _inputMode = InputMode.read;

      _lat = widget.latitude;
      _lon = widget.longitude;
    });
  }

  void _handleStartEditMode() {
    setState(() {
      _inputMode = InputMode.edit;
    });
  }

  Future<void> _resetMap(LatLng latLng) async {
    await _mapController!.updateCircle(_currentMapMarker!,
        CircleOptions(geometry: latLng, circleOpacity: 1.0));

    await _mapController!.removeCircles(_mapController!.circles.where((c) {
      return c != _currentMapMarker;
    }));

    _mapController!
        .moveCamera(CameraUpdate.newLatLngZoom(latLng, DEFAULT_ZOOM));
  }
}

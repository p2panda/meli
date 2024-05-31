// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/save_cancel_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

double DEFAULT_ZOOM = 10;
String CURRENT_FEATURE_ID = 'current';
String TARGET_FEATURE_ID = 'target';

class _LocationFieldState extends State<LocationField> {
  late double _lat;
  late double _lon;

  bool _isEditMode = false;

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

    return EditableCard(
      title: t.sightingLocationFieldTitle,
      isEditMode: _isEditMode,
      onChanged: _isEditMode
          ? _handleCancel
          : () {
              setState(() {
                _isEditMode = true;
              });
            },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _renderMap(),
        const SizedBox(
          height: 20,
        ),
        Text(t.sightingLocationLongitude(_lon),
            style: Theme.of(context).textTheme.bodyLarge),
        Text(t.sightingLocationLatitude(_lat),
            style: Theme.of(context).textTheme.bodyLarge),
        if (_isEditMode)
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SaveCancelButtons(
                  handleCancel: _handleCancel, handleSave: _handleSave)),
      ]),
    );
  }

  Widget _renderMap() {
    return Container(
        alignment: Alignment.center,
        height: 200,
        child: MaplibreMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: DEFAULT_ZOOM),
            scrollGesturesEnabled: _isEditMode,
            dragEnabled: _isEditMode,
            zoomGesturesEnabled: _isEditMode,
            trackCameraPosition: _isEditMode,
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
              if (!_isEditMode) return;
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
      _isEditMode = false;
      widget.onUpdate(latitude: _lat, longitude: _lon);
    });

    _resetMap(LatLng(_lat, _lon));
  }

  void _handleCancel() async {
    await _resetMap(LatLng(widget.latitude, widget.longitude));

    setState(() {
      _isEditMode = false;
      _lat = widget.latitude;
      _lon = widget.longitude;
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

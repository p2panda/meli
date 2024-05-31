// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/colors.dart';
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

double DEFAULT_ZOOM = 8;
String CURRENT_FEATURE_ID = 'current';
String TARGET_FEATURE_ID = 'target';

class _LocationFieldState extends State<LocationField> {
  // The latitude value displayed for the marker at the center of the map
  late double _lat;
  // The longitude value displayed for the marker at the center of the map
  late double _lng;

  bool _isEditMode = false;

  MaplibreMapController? _mapController;

  // The marker that uses the saved coordinates of the sighting
  Circle? _existingMapMarker;

  @override
  void initState() {
    _lat = widget.latitude;
    _lng = widget.longitude;
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
        Text(t.sightingLocationLongitude(_lng),
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
              _existingMapMarker = await _mapController!.addCircle(
                  createMapCircle(lat: widget.latitude, lng: widget.longitude));
            },
            onMapClick: (_, latLng) async {
              if (!_isEditMode) return;
              if (_existingMapMarker == null) return;

              var nextMarker = _mapController!.circles.where((c) {
                return c != _existingMapMarker;
              }).firstOrNull;

              // Add the "next" marker and update the visuals of the existing marker
              if (nextMarker == null) {
                await _mapController!.addCircle(createMapCircle(
                    lat: latLng.latitude, lng: latLng.longitude));

                await _mapController!.updateCircle(
                    _existingMapMarker!,
                    const CircleOptions(
                      circleOpacity: 0.5,
                      circleStrokeOpacity: 0.5,
                    ));
              } else {
                await _mapController!
                    .updateCircle(nextMarker, CircleOptions(geometry: latLng));
              }

              _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));

              setState(() {
                _lng = latLng.longitude;
                _lat = latLng.latitude;
              });
            }));
  }

  void _handleSave() async {
    // Do nothing if coordinates have not changed at all
    if (_lat == widget.latitude && _lng == widget.longitude) {
      _handleCancel();
      return;
    }

    setState(() {
      _isEditMode = false;
      widget.onUpdate(latitude: _lat, longitude: _lng);
    });

    _resetMap(LatLng(_lat, _lng));
  }

  void _handleCancel() async {
    await _resetMap(LatLng(widget.latitude, widget.longitude));

    setState(() {
      _isEditMode = false;
      _lat = widget.latitude;
      _lng = widget.longitude;
    });
  }

  Future<void> _resetMap(LatLng latLng) async {
    await _mapController!.updateCircle(
        _existingMapMarker!,
        CircleOptions(
            geometry: latLng, circleOpacity: 1.0, circleStrokeOpacity: 1.0));

    await _mapController!.removeCircles(_mapController!.circles.where((c) {
      return c != _existingMapMarker;
    }));

    _mapController!
        .animateCamera(CameraUpdate.newLatLngZoom(latLng, DEFAULT_ZOOM));
  }
}

CircleOptions createMapCircle({required double lat, required double lng}) {
  return CircleOptions(
      circleRadius: 8,
      circleColor: MeliColors.magnolia.toHexStringRGB(),
      circleStrokeColor: MeliColors.black.toHexStringRGB(),
      circleStrokeWidth: 2.0,
      geometry: LatLng(lat, lng));
}

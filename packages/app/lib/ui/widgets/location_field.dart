// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/save_cancel_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

typedef OnUpdate = void Function(Coordinates coordinates);
typedef Coordinates = ({double latitude, double longitude});

class LocationField extends StatefulWidget {
  final Coordinates? coordinates;

  final OnUpdate onUpdate;

  const LocationField(
      {super.key, required this.coordinates, required this.onUpdate});

  @override
  State<LocationField> createState() => _LocationFieldState();
}

const Coordinates BRAZIL_CENTROID_COORDINATES =
    (latitude: -14.235004, longitude: -51.92528);
const double DEFAULT_ZOOMED_OUT_LEVEL = 1.5;
const double DEFAULT_ZOOMED_IN_LEVEL = 8;

class _LocationFieldState extends State<LocationField> {
  late Coordinates? _coordinates;

  bool _isEditMode = false;

  MaplibreMapController? _mapController;

  // The marker that uses the saved coordinates of the sighting
  Circle? _existingMapMarker;

  @override
  void initState() {
    _coordinates = widget.coordinates;
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
        if (_coordinates != null) ...[
          Text(t.sightingLocationLongitude(_coordinates!.longitude),
              style: Theme.of(context).textTheme.bodyLarge),
          Text(t.sightingLocationLatitude(_coordinates!.latitude),
              style: Theme.of(context).textTheme.bodyLarge),
        ],
        if (_isEditMode)
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SaveCancelButtons(
                  handleCancel: _handleCancel, handleSave: _handleSave)),
      ]),
    );
  }

  Widget _renderMap() {
    final initialCameraPosition = _coordinates == null
        ? CameraPosition(
            zoom: DEFAULT_ZOOMED_OUT_LEVEL,
            target: LatLng(BRAZIL_CENTROID_COORDINATES.latitude,
                BRAZIL_CENTROID_COORDINATES.longitude))
        : CameraPosition(
            target: LatLng(_coordinates!.latitude, _coordinates!.longitude),
            zoom: DEFAULT_ZOOMED_IN_LEVEL);

    return Container(
        alignment: Alignment.center,
        height: 200,
        child: MaplibreMap(
            initialCameraPosition: initialCameraPosition,
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
              if (_coordinates != null) {
                _existingMapMarker = await _mapController!.addCircle(
                    createMapCircle(
                        latitude: _coordinates!.latitude,
                        longitude: _coordinates!.longitude));
              }
            },
            onMapClick: (_, latLng) async {
              if (!_isEditMode) return;

              final nextMarker = _mapController!.circles.where((c) {
                return c != _existingMapMarker;
              }).firstOrNull;

              // Add the "next" marker and update the visuals of the existing marker
              if (nextMarker == null) {
                await _mapController!.addCircle(createMapCircle(
                    latitude: latLng.latitude, longitude: latLng.longitude));

                if (_existingMapMarker != null) {
                  await _mapController!.updateCircle(
                      _existingMapMarker!,
                      const CircleOptions(
                        circleOpacity: 0.5,
                        circleStrokeOpacity: 0.5,
                      ));
                }
              } else {
                await _mapController!
                    .updateCircle(nextMarker, CircleOptions(geometry: latLng));
              }

              _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));

              setState(() {
                _coordinates =
                    (latitude: latLng.latitude, longitude: latLng.longitude);
              });
            }));
  }

  void _handleSave() async {
    // Do nothing if coordinates have not changed at all
    if (_coordinates == widget.coordinates) {
      _handleCancel();
      return;
    }

    setState(() {
      _isEditMode = false;
      if (_coordinates != null) {
        widget.onUpdate(_coordinates!);
      }
    });

    _resetMap(coordinates: _coordinates!, zoomLevel: DEFAULT_ZOOMED_IN_LEVEL);
  }

  void _handleCancel() async {
    if (widget.coordinates == null || _coordinates == null) {
      await _resetMap(
          coordinates: BRAZIL_CENTROID_COORDINATES,
          zoomLevel: DEFAULT_ZOOMED_OUT_LEVEL);
    } else {
      await _resetMap(
          coordinates: widget.coordinates!, zoomLevel: DEFAULT_ZOOMED_IN_LEVEL);
    }

    setState(() {
      _isEditMode = false;
      _coordinates = widget.coordinates;
    });
  }

  Future<void> _resetMap(
      {required Coordinates coordinates, required double zoomLevel}) async {
    final latLng = LatLng(coordinates.latitude, coordinates.longitude);

    if (_existingMapMarker != null) {
      await _mapController!.updateCircle(
          _existingMapMarker!,
          CircleOptions(
              geometry: latLng, circleOpacity: 1.0, circleStrokeOpacity: 1.0));
    }

    await _mapController!.removeCircles(_mapController!.circles.where((c) {
      return c != _existingMapMarker;
    }));

    _mapController!
        .animateCamera(CameraUpdate.newLatLngZoom(latLng, zoomLevel));
  }
}

CircleOptions createMapCircle(
    {required double latitude, required double longitude}) {
  return CircleOptions(
      circleRadius: 8,
      circleColor: MeliColors.magnolia.toHexStringRGB(),
      circleStrokeColor: MeliColors.black.toHexStringRGB(),
      circleStrokeWidth: 2.0,
      geometry: LatLng(latitude, longitude));
}

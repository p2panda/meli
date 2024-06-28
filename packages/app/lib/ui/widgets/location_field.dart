// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/action_buttons.dart';
import 'package:app/ui/widgets/editable_card.dart';
import 'package:app/ui/widgets/read_only_value.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

const EMPTY_SOURCE_GEOJSON_DATA = {
  "type": "FeatureCollection",
  // ignore: inference_failure_on_collection_literal
  "features": []
};
const SOURCE_ID = 'points';
const LAYER_ID = 'location';
const BEE_IMAGE_ID = 'bee';
const PLACEHOLDER_FEATURE_ID = 'placeholder';
const FOCUSED_FEATURE_ID = 'focused';

const SHOW_FOCUSED_FILTER_EXPRESSION = [
  Expressions.equal,
  [Expressions.id],
  FOCUSED_FEATURE_ID,
];
const SHOW_ALL_FILTER_EXPRESSION = [Expressions.literal, true];
const ICON_OPACITY_EXPRESSION = [
  Expressions.caseExpression,
  [
    Expressions.equal,
    [Expressions.id],
    PLACEHOLDER_FEATURE_ID,
  ],
  0.6,
  1
];

class _LocationFieldState extends State<LocationField> {
  // Represents the coordinates used for the focused symbol on the map (i.e. what's centered on the map)
  late Coordinates? _coordinates;

  bool _isEditMode = false;

  MapLibreMapController? _mapController;

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
      onChanged: _isEditMode ? _handleCancel : _handleStartEdit,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _renderMap(),
        const SizedBox(
          height: 20,
        ),
        if (_coordinates == null)
          ReadOnlyValue(t.sightingLocationNoLocation)
        else ...[
          Text(t.sightingLocationLongitude(_coordinates!.longitude),
              style: Theme.of(context).textTheme.bodyLarge),
          Text(t.sightingLocationLatitude(_coordinates!.latitude),
              style: Theme.of(context).textTheme.bodyLarge),
        ],
        if (_isEditMode)
          Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child:
                  ActionButtons(onCancel: _handleCancel, onAction: _handleSave))
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
        child: MapLibreMap(
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
          onStyleLoadedCallback: _handleMapStyleLoaded,
          onMapClick: _handleMapPress,
        ));
  }

  Future<void> _handleMapStyleLoaded() async {
    // Load asset used for symbol marker
    final bytes = await rootBundle.load("assets/images/meliponini.png");
    final list = bytes.buffer.asUint8List();
    _mapController!.addImage(BEE_IMAGE_ID, list);

    // Create source
    await _mapController!.addGeoJsonSource(
        SOURCE_ID,
        _coordinates == null
            ? EMPTY_SOURCE_GEOJSON_DATA
            : createSourceData(focusedCoord: _coordinates!));

    // Create layer
    await _mapController!.addSymbolLayer(
        SOURCE_ID,
        LAYER_ID,
        const SymbolLayerProperties(
          iconImage: BEE_IMAGE_ID,
          iconSize: 0.07,
          iconAllowOverlap: true,
          iconOpacity: ICON_OPACITY_EXPRESSION,
        ),
        enableInteraction: false,
        filter: SHOW_FOCUSED_FILTER_EXPRESSION);
  }

  Future<void> _handleMapPress(_, LatLng latLng) async {
    if (!_isEditMode) return;

    _mapController!.setGeoJsonSource(
        SOURCE_ID,
        createSourceData(focusedCoord: (
          latitude: latLng.latitude,
          longitude: latLng.longitude
        ), placeholderCoord: widget.coordinates));

    _mapController!.setFilter(LAYER_ID, SHOW_ALL_FILTER_EXPRESSION);

    _mapController!.animateCamera(CameraUpdate.newLatLng(latLng));

    setState(() {
      _coordinates = (latitude: latLng.latitude, longitude: latLng.longitude);
    });
  }

  Future<void> _handleStartEdit() async {
    if (widget.coordinates == null) {
      await _mapController!.setGeoJsonSource(SOURCE_ID,
          createSourceData(focusedCoord: BRAZIL_CENTROID_COORDINATES));

      setState(() {
        _coordinates = (
          latitude: BRAZIL_CENTROID_COORDINATES.latitude,
          longitude: BRAZIL_CENTROID_COORDINATES.longitude
        );
      });
    }

    setState(() {
      _isEditMode = true;
    });
  }

  void _handleSave() async {
    // Do nothing if coordinates they are not set or have not changed at all
    if (_coordinates == null || _coordinates == widget.coordinates) {
      _handleCancel();
      return;
    }

    setState(() {
      _isEditMode = false;
    });

    if (_coordinates != null) {
      widget.onUpdate(_coordinates!);
    }

    await _resetMap(
        data: createSourceData(focusedCoord: _coordinates!),
        cameraCoordinates: _coordinates!,
        cameraZoom: DEFAULT_ZOOMED_IN_LEVEL);
  }

  void _handleCancel() async {
    setState(() {
      _isEditMode = false;
    });

    if (widget.coordinates == null) {
      await _resetMap(
          data: EMPTY_SOURCE_GEOJSON_DATA,
          cameraCoordinates: BRAZIL_CENTROID_COORDINATES,
          cameraZoom: DEFAULT_ZOOMED_OUT_LEVEL);
    } else {
      await _resetMap(
        data: createSourceData(focusedCoord: widget.coordinates!),
        cameraCoordinates: widget.coordinates!,
        cameraZoom: DEFAULT_ZOOMED_IN_LEVEL,
      );
    }

    setState(() {
      _coordinates = widget.coordinates;
    });
  }

  Future<void> _resetMap({
    required Map<String, dynamic> data,
    required Coordinates cameraCoordinates,
    required double cameraZoom,
  }) async {
    await _mapController!.setGeoJsonSource(SOURCE_ID, data);
    await _mapController!.setFilter(LAYER_ID, SHOW_FOCUSED_FILTER_EXPRESSION);
    await _mapController!.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(cameraCoordinates.latitude, cameraCoordinates.longitude),
        cameraZoom));
  }
}

Map<String, dynamic> createSourceData(
    {required Coordinates focusedCoord, Coordinates? placeholderCoord}) {
  return {
    "type": "FeatureCollection",
    "features": [
      {
        "type": "Feature",
        "id": FOCUSED_FEATURE_ID,
        // ignore: inference_failure_on_collection_literal
        "properties": {},
        "geometry": {
          "type": "Point",
          "coordinates": [focusedCoord.longitude, focusedCoord.latitude]
        }
      },
      if (placeholderCoord != null)
        {
          "type": "Feature",
          "id": PLACEHOLDER_FEATURE_ID,
          // ignore: inference_failure_on_collection_literal
          "properties": {},
          "geometry": {
            "type": "Point",
            "coordinates": [
              placeholderCoord.longitude,
              placeholderCoord.latitude
            ]
          }
        }
    ],
  };
}

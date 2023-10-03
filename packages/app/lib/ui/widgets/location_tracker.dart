// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';

enum LocationTrackerStatus {
  Standby,
  Waiting,
  Active,
  Failure,
}

typedef AddLocation = void Function();

typedef RemoveLocation = void Function();

typedef LocationTrackerBuilder = Widget Function(
  Position? position,
  LocationTrackerStatus status, {
  String? errorMessage,
  AddLocation? addLocation,
  RemoveLocation? removeLocation,
});

class LocationTracker extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;
  final LocationTrackerBuilder builder;

  LocationTracker({super.key, required this.builder, this.onPositionChanged});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  /// Locale provider instance.
  AppLocalizations? _locale;

  /// Current position value which is exposed to other widgets.
  Position? _position;

  /// Current status of the position tracker.
  LocationTrackerStatus _status = LocationTrackerStatus.Standby;

  /// Keep track of the last known error.
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._locale = AppLocalizations.of(context);
    });
  }

  Position? getPosition() {
    return this._position;
  }

  void _updatePosition(Position? value) {
    this._position = value;

    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!.call(value);
    }
  }

  void _addLocation() async {
    setState(() {
      this._status = LocationTrackerStatus.Waiting;
      this._errorMessage = null;
    });

    try {
      // Retrieve position from location service
      final position = await determinePosition();

      // Inform external widgets about the position or handle potential errors
      this._updatePosition(position);
      this._status = LocationTrackerStatus.Active;
    } on PermissionDeniedException {
      this._errorMessage = _locale!.locationErrorPermissionDenied;
    } on LocationServiceDisabledException {
      this._errorMessage = _locale!.locationErrorServiceDisabled;
    } on TimeoutException {
      this._errorMessage = _locale!.locationErrorTimeout;
    } catch (error) {
      this._errorMessage = _locale!.locationErrorUnknown;
    } finally {
      this._status = this._errorMessage != null
          ? LocationTrackerStatus.Failure
          : this._status;

      // Force refresh UI
      setState(() {});
    }
  }

  void _removeLocation() {
    setState(() {
      this._status = LocationTrackerStatus.Standby;
    });

    this._updatePosition(null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this._position, this._status,
        errorMessage: this._errorMessage,
        addLocation: this._addLocation,
        removeLocation: this._removeLocation);
  }
}

class LocationTrackerInput extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;

  LocationTrackerInput({super.key, this.onPositionChanged});

  @override
  State<LocationTrackerInput> createState() => _LocationTrackerInputState();
}

class _LocationTrackerInputState extends State<LocationTrackerInput> {
  final GlobalKey<_LocationTrackerState> trackerKey = GlobalKey();
  AppLocalizations? _locale;

  /// User confirmed that they want to track their location. This does not have
  /// anything to do with the device's permission settings but merely with the
  /// user interface in the Meli app.
  bool _hasUserGivenConsent = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._locale = AppLocalizations.of(context);
    });
  }

  Position? getPosition() {
    return this.trackerKey.currentState!.getPosition();
  }

  Widget _standby(AddLocation? addLocation) {
    return Column(children: [
      Text('Do you want to add a GPS location?'),
      TextButton(
          child: Text('Add location to image'),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = true;
            });

            addLocation!();
          }),
    ]);
  }

  Widget _waiting() {
    return Text('Retreiving location ...');
  }

  Widget _success(Position position, RemoveLocation? removeLocation) {
    final latitude = position.latitude;
    final longitude = position.longitude;

    return Column(children: [
      Text('Location recorded: $latitude $longitude'),
      TextButton(
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = false;
            });

            removeLocation!();
          },
          child: Text('Remove location'))
    ]);
  }

  Widget _failed(String errorMessage, AddLocation? addLocation) {
    return Column(children: [
      Text(errorMessage),
      Text(this._locale!.locationTryAgain),
      TextButton(
          onPressed: addLocation,
          child: Text(this._locale!.locationTryAgainAction))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return LocationTracker(
        key: trackerKey,
        builder: (Position? position, LocationTrackerStatus status,
            {String? errorMessage,
            AddLocation? addLocation,
            RemoveLocation? removeLocation}) {
          if (!this._hasUserGivenConsent) {
            return this._standby(addLocation);
          }

          switch (status) {
            case LocationTrackerStatus.Standby:
            case LocationTrackerStatus.Waiting:
              return this._waiting();
            case LocationTrackerStatus.Active:
              return this._success(position!, removeLocation);
            case LocationTrackerStatus.Failure:
              return this._failed(errorMessage!, addLocation);
          }
        },
        onPositionChanged: (Position? value) {
          if (widget.onPositionChanged != null) {
            widget.onPositionChanged!.call(value);
          }
        });
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';

enum TrackerStatus {
  Standby,
  Waiting,
  Active,
  Failure,
}

class LocationTracker extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;

  LocationTracker({super.key, this.onPositionChanged});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  /// Locale provider instance.
  AppLocalizations? _locale;

  /// Current position value which is exposed to other widgets.
  Position? _position;

  /// Current status of the position tracker.
  TrackerStatus _status = TrackerStatus.Standby;

  /// Keep track of the last known error.
  String? _errorMessage;

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

  Future<Position?> getPosition() async {
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
      this._status = TrackerStatus.Waiting;
      this._errorMessage = null;
    });

    try {
      final position = await determinePosition();
      this._updatePosition(position);
      this._status = TrackerStatus.Active;
    } on PermissionDeniedException {
      this._errorMessage = _locale!.locationErrorPermissionDenied;
    } on LocationServiceDisabledException {
      this._errorMessage = _locale!.locationErrorServiceDisabled;
    } on TimeoutException {
      this._errorMessage = _locale!.locationErrorTimeout;
    } catch (error) {
      this._errorMessage = _locale!.locationErrorUnknown;
    } finally {
      this._status =
          this._errorMessage != null ? TrackerStatus.Failure : this._status;
      setState(() {});
    }
  }

  void _removeLocation() {
    setState(() {
      this._status = TrackerStatus.Standby;
    });

    this._updatePosition(null);
  }

  Widget _standby() {
    return Column(children: [
      Text('Do you want to add a GPS location?'),
      TextButton(
          child: Text('Add location to image'),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = true;
            });

            _addLocation();
          }),
    ]);
  }

  Widget _waiting() {
    return Text('Retreiving location ...');
  }

  Widget _success() {
    if (this._position == null) {
      return SizedBox.shrink();
    }

    final latitude = this._position!.latitude;
    final longitude = this._position!.longitude;

    return Column(children: [
      Text('Location recorded: $latitude $longitude'),
      TextButton(
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = false;
            });

            _removeLocation();
          },
          child: Text('Remove location'))
    ]);
  }

  Widget _failed() {
    return Column(children: [
      Text(this._errorMessage!),
      Text(this._locale!.locationTryAgain),
      TextButton(
          onPressed: _addLocation,
          child: Text(this._locale!.locationTryAgainAction))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (!this._hasUserGivenConsent) {
      return this._standby();
    }

    switch (this._status) {
      case TrackerStatus.Standby:
      case TrackerStatus.Waiting:
        return this._waiting();
      case TrackerStatus.Active:
        return this._success();
      case TrackerStatus.Failure:
        return this._failed();
    }
  }
}

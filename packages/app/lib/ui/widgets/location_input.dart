// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/ui/widgets/location_tracker.dart';

class LocationInput extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;

  LocationInput({super.key, this.onPositionChanged});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  /// Current position value which is exposed to other widgets.
  Position? _position;

  /// User confirmed that they want to track their location. This does not have
  /// anything to do with the device's permission settings but merely with the
  /// user interface in the Meli app.
  bool _hasUserGivenConsent = false;

  Future<Position?> getPosition() async {
    return this._position;
  }

  void _updatePosition(Position? value) {
    this._position = value;

    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!.call(value);
    }
  }

  Widget _standby(Function addTracking) {
    return Column(children: [
      Text('Do you want to add a GPS location?'),
      TextButton(
          child: Text('Add location to image'),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = true;
            });

            addTracking();
          }),
    ]);
  }

  Widget _waiting() {
    return Text('Retreiving location ...');
  }

  Widget _success(Position position, Function removeTracking) {
    final latitude = position.latitude;
    final longitude = position.longitude;

    return Column(children: [
      Text('Location recorded: $latitude $longitude'),
      TextButton(
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = false;
            });

            removeTracking();
          },
          child: Text('Remove location'))
    ]);
  }

  Widget _failed(Exception error) {
    try {
      throw error;
    } on PermissionDeniedException {
      return Text('Could not retreive location: $error');
    } on LocationServiceDisabledException {
      return Text('Could not retreive location: $error');
    } catch (error) {
      return Text('Could not retreive location: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocationTracker(builder: (Position? position, TrackerStatus status,
        Exception? lastError, Function addLocation, Function removeLocation) {
      if (!this._hasUserGivenConsent) {
        return this._standby(addLocation);
      }

      switch (status) {
        case TrackerStatus.Standby:
        case TrackerStatus.Waiting:
          return this._waiting();
        case TrackerStatus.Active:
          return this._success(position!, removeLocation);
        case TrackerStatus.Failure:
          return this._failed(lastError!);
      }
    }, onPositionChanged: (Position? position) {
      this._updatePosition(position);
    });
  }
}

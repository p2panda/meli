// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';

enum TrackerStatus {
  Standby,
  Waiting,
  Active,
  Failure,
}

typedef LocationTrackerBuilder = Widget Function(
  Position? position,
  TrackerStatus status,
  Exception? lastError,
  Function addLocation,
  Function removeLocation,
);

class LocationTracker extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;
  final LocationTrackerBuilder builder;

  LocationTracker({super.key, required this.builder, this.onPositionChanged});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  /// Current position value which is exposed to other widgets.
  Position? _position;

  /// Current status of the position tracker.
  TrackerStatus _status = TrackerStatus.Standby;

  /// Keep track of the last known error.
  Exception? _lastError;

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
    });

    try {
      final position = await determinePosition();

      setState(() {
        this._updatePosition(position);
        this._status = TrackerStatus.Active;
      });
    } catch (error) {
      setState(() {
        this._lastError = error as Exception;
        this._status = TrackerStatus.Failure;
      });
    }
  }

  void _removeLocation() {
    setState(() {
      this._status = TrackerStatus.Standby;
    });

    this._updatePosition(null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        _position, _status, _lastError, _addLocation, _removeLocation);
  }
}

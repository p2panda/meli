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

  /// Current status of the position tracker stream.
  TrackerStatus _status = TrackerStatus.Standby;

  /// Internal position value. We keep this to restore it as soon as the user
  /// decides to track their position _again_.
  Position? _lastKnownPosition;

  /// Controller managing the position stream.
  StreamController<Position> _streamController = new StreamController();

  /// Handler of the stream subscriber. We need this pointer to dispose it correctly.
  StreamSubscription<Position>? _subscription;

  /// Keep track of the last known error.
  Exception? _lastError;

  /// Flag to make sure that we only start the position tracker stream once.
  bool _hasTrackerStarted = false;

  Future<Position?> getPosition() async {
    return this._position;
  }

  void _updatePosition(Position? value) {
    this._position = value;

    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!.call(value);
    }
  }

  void _addLocation() {
    this._updatePosition(this._lastKnownPosition);
    this._subscribe();
  }

  void _removeLocation() {
    this._updatePosition(null);
  }

  void _subscribe() async {
    // Make sure to only start stream once
    if (this._hasTrackerStarted) {
      return;
    }
    this._hasTrackerStarted = true;

    // Set up state machine reading from position stream
    setState(() {
      this._status = TrackerStatus.Waiting;
    });

    this._subscription = _streamController.stream.listen((Position? position) {
      if (position != null) {
        setState(() {
          this._updatePosition(position);
          this._lastKnownPosition = position;
          this._status = TrackerStatus.Active;
        });
      }
    }, onError: (dynamic error) {
      setState(() {
        this._lastError = error as Exception;
        this._status = TrackerStatus.Failure;
      });
    });

    // Attempt access to geolocation API of device and establish an async
    // stream of position data coming in. This can fail when we haven't
    // received any permission to track the location of this device for
    // example.
    try {
      final positionStream = await trackPosition();
      _streamController.addStream(positionStream);
    } catch (error) {
      _streamController.addError(error);
    }
  }

  void _unsubscribe() async {
    if (this._subscription != null) {
      await this._subscription!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        _position, _status, _lastError, _addLocation, _removeLocation);
  }

  @override
  void dispose() {
    this._unsubscribe();
    super.dispose();
  }
}

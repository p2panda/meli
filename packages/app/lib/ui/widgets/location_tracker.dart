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

class LocationTracker extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;

  LocationTracker({super.key, this.onPositionChanged});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  /// Current position value which is exposed to other widgets.
  Position? _value;

  /// Current status of the position tracker stream.
  TrackerStatus _trackerStatus = TrackerStatus.Standby;

  /// Internal position value. We keep this to restore it as soon as the user
  /// decides to track their position _again_.
  Position? _lastValue;

  /// Controller managing the position stream.
  StreamController<Position> _streamController = new StreamController();

  /// Handler of the stream subscriber. We need this pointer to dispose it correctly.
  StreamSubscription<Position>? _subscription;

  /// Keep track of the last known error.
  dynamic _lastError;

  /// User confirmed that they want to track their location. This does not have
  /// anything to do with the device's permission settings but merely with the
  /// user interface in the Meli app.
  bool _hasUserGivenConsent = false;

  /// Flag to make sure that we only start the position tracker stream once.
  bool _hasTrackerStarted = false;

  Future<Position?> getValue() async {
    return this._value;
  }

  void _updatePosition(Position? value) {
    this._value = value;

    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!.call(value);
    }
  }

  void _addTracking() {
    setState(() {
      this._updatePosition(this._lastValue);
      _hasUserGivenConsent = true;
    });

    this._startStream();
  }

  void _removeTracking() {
    this._updatePosition(null);

    setState(() {
      _hasUserGivenConsent = false;
    });
  }

  void _startStream() async {
    // Make sure to only start stream once
    if (this._hasTrackerStarted) {
      return;
    }
    this._hasTrackerStarted = true;

    // Set up state machine reading from position stream
    setState(() {
      this._trackerStatus = TrackerStatus.Waiting;
    });

    this._subscription = _streamController.stream.listen((Position? position) {
      if (position != null) {
        setState(() {
          this._trackerStatus = TrackerStatus.Active;
          this._lastValue = position;

          if (this._hasUserGivenConsent) {
            this._updatePosition(position);
          }
        });
      }
    }, onError: (dynamic error) {
      setState(() {
        this._trackerStatus = TrackerStatus.Failure;
        this._lastError = error;
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

  Widget _standby() {
    return Column(children: [
      Text('Do you want to add a GPS location?'),
      TextButton(
          child: Text('Add location to image'),
          onPressed: () {
            this._addTracking();
          }),
    ]);
  }

  Widget _waiting() {
    return Text('Retreiving location ...');
  }

  Widget _success() {
    if (this._value == null) {
      return SizedBox.shrink();
    }

    final latitude = this._value!.latitude;
    final longitude = this._value!.longitude;

    return Column(children: [
      Text('Location recorded: $latitude $longitude'),
      TextButton(
          onPressed: () {
            this._removeTracking();
          },
          child: Text('Remove location'))
    ]);
  }

  Widget _failed() {
    final error =
        this._lastError != null ? this._lastError!.toString() : 'Unknown error';
    return Text('Could not retreive location: $error');
  }

  @override
  Widget build(BuildContext context) {
    if (!this._hasUserGivenConsent) {
      return this._standby();
    } else {
      switch (this._trackerStatus) {
        case TrackerStatus.Standby:
          return this._standby();
        case TrackerStatus.Waiting:
          return this._waiting();
        case TrackerStatus.Active:
          return this._success();
        case TrackerStatus.Failure:
          return this._failed();
      }
    }
  }

  @override
  void dispose() async {
    super.dispose();

    // Make sure to close position stream
    if (this._subscription != null) {
      await this._subscription!.cancel();
    }
  }
}

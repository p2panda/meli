// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';

class LocationTracker extends StatefulWidget {
  LocationTracker({super.key});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  StreamController<Position> streamController = new StreamController();

  // Attempt access to geolocation API of device and establish an async stream
  // of position data coming in. This can fail when we haven't received any
  // permission to track the location of this device for example.
  _enablePositionTracker() {
    _initStream() async {
      try {
        final positionStream = await trackPosition();
        streamController.addStream(positionStream);
      } catch (error) {
        streamController.addError(error);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Location Tracker Test'),
      StreamBuilder(
          stream: this.streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error!.toString());
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.done:
                case ConnectionState.waiting:
                  return Text('State = Standby');
                case ConnectionState.active:
                  final latitude = snapshot.data!.latitude;
                  final longitude = snapshot.data!.longitude;
                  return Text('Position: $latitude $longitude');
              }
            }
          }),
    ]);
  }
}

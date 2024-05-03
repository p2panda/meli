// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import 'package:app/io/geolocation.dart';
import 'package:app/ui/widgets/button.dart';
import 'package:app/ui/widgets/simple_card.dart';

enum LocationTrackerStatus {
  Standby,
  Waiting,
  Active,
  Failure,
}

typedef LocationTrackerBuilder = Widget Function(
  Position? position,
  LocationTrackerStatus status, {
  String? errorMessage,
  VoidCallback? addLocation,
  VoidCallback? removeLocation,
});

class LocationTracker extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;
  final LocationTrackerBuilder builder;

  const LocationTracker({super.key, required this.builder, this.onPositionChanged});

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  /// Current position value which is exposed to other widgets.
  Position? _position;

  /// Current status of the position tracker.
  LocationTrackerStatus _status = LocationTrackerStatus.Standby;

  /// Keep track of the last known error.
  String? _errorMessage;

  Position? getPosition() {
    return _position;
  }

  void _updatePosition(Position? value) {
    _position = value;

    if (widget.onPositionChanged != null) {
      widget.onPositionChanged!.call(value);
    }
  }

  void _addLocation() async {
    final t = AppLocalizations.of(context)!;

    setState(() {
      _status = LocationTrackerStatus.Waiting;
      _errorMessage = null;
    });

    try {
      // Retrieve position from location service
      final position = await determinePosition();

      // Inform external widgets about the position or handle potential errors
      _updatePosition(position);
      _status = LocationTrackerStatus.Active;
    } on PermissionDeniedException {
      _errorMessage = t.locationErrorPermissionDenied;
    } on LocationServiceDisabledException {
      _errorMessage = t.locationErrorServiceDisabled;
    } on TimeoutException {
      _errorMessage = t.locationErrorTimeout;
    } catch (error) {
      _errorMessage = t.locationErrorUnknown;
    } finally {
      _status = _errorMessage != null
          ? LocationTrackerStatus.Failure
          : _status;

      // Force refresh UI
      setState(() {});
    }
  }

  void _removeLocation() {
    setState(() {
      _status = LocationTrackerStatus.Standby;
    });

    _updatePosition(null);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_position, _status,
        errorMessage: _errorMessage,
        addLocation: _addLocation,
        removeLocation: _removeLocation);
  }
}

class LocationTrackerInput extends StatefulWidget {
  final ValueChanged<Position?>? onPositionChanged;

  const LocationTrackerInput({super.key, this.onPositionChanged});

  @override
  State<LocationTrackerInput> createState() => _LocationTrackerInputState();
}

class _LocationTrackerInputState extends State<LocationTrackerInput> {
  final GlobalKey<_LocationTrackerState> _trackerKey = GlobalKey();

  /// User confirmed that they want to track their location. This does not have
  /// anything to do with the device's permission settings but merely with the
  /// user interface in the Meli app.
  bool _hasUserGivenConsent = false;

  Position? getPosition() {
    return _trackerKey.currentState!.getPosition();
  }

  Widget _header(IconData icon, String text) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.black,
            ),
            const SizedBox(height: 10),
            Text(text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ));
  }

  Widget _standby(VoidCallback? addLocation) {
    final t = AppLocalizations.of(context)!;

    return Wrap(runSpacing: 10.0, alignment: WrapAlignment.center, children: [
      _header(Icons.location_searching, t.locationAdd),
      MeliIconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = true;
            });

            addLocation!();
          },
          child: Text(t.locationAddAction)),
    ]);
  }

  Widget _waiting() {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: [
        const SizedBox(
            width: 30.0,
            height: 30.0,
            child: CircularProgressIndicator(
                color: Colors.black, strokeWidth: 3.0)),
        const SizedBox(height: 15),
        Text(t.locationLoading, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  Widget _success(Position position, VoidCallback? removeLocation) {
    final t = AppLocalizations.of(context)!;

    final latitude = position.latitude;
    final longitude = position.longitude;

    return Wrap(runSpacing: 10.0, alignment: WrapAlignment.center, children: [
      _header(Icons.where_to_vote_rounded,
          t.locationSuccessful(latitude, longitude)),
      MeliIconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            setState(() {
              _hasUserGivenConsent = false;
            });

            removeLocation!();
          },
          child: Text(t.locationRemoveAction)),
    ]);
  }

  Widget _failed(String errorMessage, VoidCallback? addLocation) {
    final t = AppLocalizations.of(context)!;

    return Wrap(runSpacing: 10.0, alignment: WrapAlignment.center, children: [
      _header(Icons.wrong_location_rounded, errorMessage),
      Text(t.locationTryAgain, style: Theme.of(context).textTheme.bodyLarge),
      MeliIconButton(
          icon: const Icon(Icons.loop),
          onPressed: addLocation,
          child: Text(t.locationTryAgainAction)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SimpleCard(
        title: t.locationHeader,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 30.0),
          child: LocationTracker(
              key: _trackerKey,
              builder: (Position? position, LocationTrackerStatus status,
                  {String? errorMessage,
                  VoidCallback? addLocation,
                  VoidCallback? removeLocation}) {
                if (!_hasUserGivenConsent) {
                  return _standby(addLocation);
                }

                switch (status) {
                  case LocationTrackerStatus.Standby:
                  case LocationTrackerStatus.Waiting:
                    return _waiting();
                  case LocationTrackerStatus.Active:
                    return _success(position!, removeLocation);
                  case LocationTrackerStatus.Failure:
                    return _failed(errorMessage!, addLocation);
                }
              },
              onPositionChanged: (Position? value) {
                if (widget.onPositionChanged != null) {
                  widget.onPositionChanged!.call(value);
                }
              }),
        ));
  }
}

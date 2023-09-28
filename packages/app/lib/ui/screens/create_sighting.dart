// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/image_provider.dart';
import 'package:flutter/material.dart';

import 'package:app/router.dart';
import 'package:app/ui/widgets/sighting_form.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/models/sightings.dart';

class CreateNewScreen extends StatefulWidget {
  CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
      title: 'Create new',
      floatingActionButtons: [
        MeliFloatingActionButton(
            heroTag: 'create_new',
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: () {
              MeliCameraProviderInherited.of(context).capturePhoto();
            }),
        MeliFloatingActionButton(
            heroTag: 'create_new',
            icon: Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Create sighting data
                try {
                  // TODO: populate all fields from form
                  DateTime datetime = DateTime.now();
                  await createSighting(datetime, 0.0, 0.0, [], null, null,
                      "Some comment about this sighting");

                  // Go back to sightings overview
                  router.push(RoutePaths.allSightings.path);

                  // Show notification
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Yay! Created new sighting'),
                  ));
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Something went wrong: $err'),
                  ));
                }
              }
            }),
      ],
      body: CreateSightingForm(formKey: this._formKey),
    );
  }
}

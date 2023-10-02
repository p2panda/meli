// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/router.dart';
import 'package:app/ui/widgets/sighting_form.dart';
import 'package:app/ui/widgets/expandable_fab.dart';
import 'package:app/ui/widgets/image_provider.dart';
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
  bool _initialImagePickAttemptComplete = false;

  Widget _buildScreen(BuildContext context) {
    final cameraImageProvider = MeliCameraProviderInherited.of(context);

    return MeliScaffold(
      title: 'Create new',
      floatingActionButtons: [
        ExpandableFab(
          icon: const Icon(Icons.add_a_photo),
          expandDirection: ExpandDirection.right,
          distance: 80,
          children: [
            ActionButton(
              onPressed: cameraImageProvider.pickFromGallery,
              icon: const Icon(Icons.insert_photo_outlined),
            ),
            ActionButton(
              onPressed: cameraImageProvider.capturePhoto,
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        MeliFloatingActionButton(
            heroTag: 'submit',
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

  @override
  Widget build(BuildContext context) {
    // Check if we already attempted to pick an initial image, immediately return
    // the child wrapped in the image provider if so.
    if (_initialImagePickAttemptComplete) {
      return _buildScreen(context);
    }

    // On initial build we want to go straight to the camera so the user can choose
    // an image before being shown child widget.
    final cameraImageProvider = MeliCameraProviderInherited.of(context);
    return FutureBuilder(
        // Trigger capturing a photo, this displays the camera view.
        future: cameraImageProvider.capturePhoto(),
        builder: (context, snapshot) {
          _initialImagePickAttemptComplete = true;

          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('ImageProvider Error: ${snapshot.error}'),
            ));
            router.push(RoutePaths.allSightings.path);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _buildScreen(context);
          }

          return Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularProgressIndicator(
                  color: Colors.grey,
                  semanticsLabel: 'Circular progress indicator',
                ),
              ],
            ),
          );
        });
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/blobs.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/expandable_fab.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/image_provider.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/sighting_form.dart';

class CreateSightingScreen extends StatefulWidget {
  CreateSightingScreen({super.key});

  @override
  State<CreateSightingScreen> createState() => _CreateSightingScreenState();
}

class _CreateSightingScreenState extends State<CreateSightingScreen> {
  final _formKey = GlobalKey<FormState>();
  List<File> images = [];
  bool _initialImageCaptured = false;

  void removeImageAt(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void addImage(File file) {
    setState(() {
      images.insert(0, file);
    });
  }

  void addAllImages(List<File> files) {
    setState(() {
      images.insertAll(0, files);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // This method is called directly after `initState`. We trigger the initial
  // image capture event here as it is safe to depend on inherited widgets (not
  // possible in `initState`) as well as trigger navigation events (not
  // recommended in build).
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    MeliCameraProviderInherited.of(context).capturePhoto().then((file) {
      if (file != null) {
        addImage(file);
      } else {
        // If no file was captured navigate back to all sightings screen.
        router.push(RoutePaths.allSightings.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If no images have been captured yet then return a spinner.
    if (images.isEmpty && !_initialImageCaptured) {
      return Container(
        color: MeliColors.black,
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
    }

    _initialImageCaptured = true;

    // If images were successfully captured return the full view.
    return MeliScaffold(
      title: 'Create new',
      floatingActionButtons: [
        ExpandableFab(
          icon: const Icon(Icons.add_a_photo),
          expandDirection: ExpandDirection.right,
          distance: 80,
          buttons: [
            ActionButton(
              onPressed: () async {
                List<File> newImages =
                    await MeliCameraProviderInherited.of(context)
                        .pickFromGallery();
                addAllImages(newImages);
              },
              icon: const Icon(Icons.insert_photo_outlined),
            ),
            ActionButton(
              onPressed: () async {
                File? newImage = await MeliCameraProviderInherited.of(context)
                    .capturePhoto();
                if (newImage != null) {
                  addImage(newImage);
                }
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        MeliFloatingActionButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Create sighting data
                try {
                  // TODO: populate all fields from form
                  DateTime datetime = DateTime.now();

                  // Publish each image as a blob and collect ids in a list.
                  List<DocumentViewId> imageIds = [];
                  try {
                    List<DocumentViewId> response =
                        await Future.wait(images.map((image) async {
                      return await publishBlob(image);
                    }));
                    imageIds.addAll(response);
                  } catch (e) {
                    print('Error publishing blob: ${e}');
                  }

                  // Publish the sighting.
                  await createSighting(datetime, 0.0, 0.0,
                      'Some comment about this sighting', imageIds, null, null);

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
      body: CreateSightingForm(
          formKey: this._formKey,
          images: this.images,
          onDeleteImage: this.removeImageAt),
    );
  }
}

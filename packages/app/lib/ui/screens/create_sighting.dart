// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/p2panda/publish.dart';
import 'package:app/models/blobs.dart';
import 'package:app/models/local_names.dart';
import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/colors.dart';
import 'package:app/ui/widgets/autocomplete.dart';
import 'package:app/ui/widgets/expandable_fab.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/image_carousel.dart';
import 'package:app/ui/widgets/image_provider.dart';
import 'package:app/ui/widgets/loading_overlay.dart';
import 'package:app/ui/widgets/local_name_autocomplete.dart';
import 'package:app/ui/widgets/location_tracker.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/ui/widgets/simple_card.dart';
import 'package:app/utils/sleep.dart';

const String PLACEHOLDER_IMG = 'assets/images/placeholder-bee.png';

class CreateSightingScreen extends StatefulWidget {
  CreateSightingScreen({super.key});

  @override
  State<CreateSightingScreen> createState() => _CreateSightingScreenState();
}

class _CreateSightingScreenState extends State<CreateSightingScreen> {
  final GlobalKey<LoadingOverlayState> _overlayKey = GlobalKey();

  List<File> images = [];
  AutocompleteItem? localName;
  double latitude = 0.0;
  double longitude = 0.0;

  bool _initialImageCaptured = false;

  void _removeImageAt(int index) {
    setState(() {
      images.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(AppLocalizations.of(context)!.imageDeleteConfirmation),
    ));
  }

  void _addImage(File file) {
    setState(() {
      images.insert(0, file);
    });
  }

  void _addAllImages(List<File> files) {
    setState(() {
      images.insertAll(0, files);
    });
  }

  void _pickFromGallery() async {
    List<File> newImages =
        await MeliCameraProviderInherited.of(context).pickFromGallery();
    this._addAllImages(newImages);
  }

  void _capturePhoto() async {
    File? newImage =
        await MeliCameraProviderInherited.of(context).capturePhoto();
    if (newImage != null) {
      this._addImage(newImage);
    }
  }

  void _onImageDelete(int imageIndex) {
    final t = AppLocalizations.of(context)!;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(t.imageDeleteAlertTitle),
        content: Text(t.imageDeleteAlertBody),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.imageDeleteAlertCancel),
          ),
          TextButton(
            onPressed: () {
              this._removeImageAt(imageIndex);
              Navigator.pop(context);
            },
            child: Text(t.imageDeleteAlertConfirm),
          ),
        ],
      ),
    );
  }

  void _createSighting() async {
    final t = AppLocalizations.of(context)!;

    _overlayKey.currentState!.show();

    try {
      DateTime datetime = DateTime.now();

      // Publish each image as a blob on the node and collect ids in a list
      List<DocumentViewId> imageIds = [];
      for (final image in images) {
        final imageId = await publishBlob(image);
        imageIds.add(imageId);
      }

      // Check if local name already exists, otherwise create a new one
      DocumentId? localNameId;
      if (localName != null) {
        if (localName!.documentId != null) {
          localNameId = localName!.documentId;
        } else {
          localNameId = await createLocalName(localName!.value);
        }
      }

      // Publish the sighting
      await createSighting(
          datetime, latitude, longitude, '', imageIds, null, localNameId);

      // .. wait a little bit
      await sleep(500);

      // Go back to sightings overview
      router.pop();

      // Show notification
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.createSightingSuccess),
      ));
    } catch (error) {
      print(error);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(t.createSightingError(error)),
      ));
    } finally {
      _overlayKey.currentState!.hide();
    }
  }

  // This method is called directly after `initState`. We trigger the initial
  // image capture event here as it is safe to depend on inherited widgets (not
  // possible in `initState`) as well as trigger navigation events (not
  // recommended in build).
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    MeliCameraProviderInherited.of(context)
        .retrieveLostData()
        .then((file) => {if (file != null) this._addImage(file)});

    MeliCameraProviderInherited.of(context).capturePhoto().then((file) {
      if (file != null) {
        this._initialImageCaptured = true;
        this._addImage(file);
      } else {
        // If no file was captured navigate back to all sightings screen
        router.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Show spinner while user is asked to take a picture with the camera for
    // the first time
    if (images.isEmpty && !_initialImageCaptured) {
      return Container(
        color: MeliColors.black,
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
          ),
        ),
      );
    }

    return LoadingOverlay(
      key: _overlayKey,
      child: MeliScaffold(
        title: t.createSightingScreenTitle,
        backgroundColor: MeliColors.electric,
        floatingActionButtons: [
          ExpandableFab(
            icon: const Icon(Icons.add_a_photo_outlined),
            expandDirection: ExpandDirection.right,
            distance: 80,
            color: MeliColors.sea,
            buttons: [
              ActionButton(
                onPressed: this._pickFromGallery,
                color: MeliColors.sea,
                icon: const Icon(Icons.insert_photo_outlined),
              ),
              ActionButton(
                onPressed: this._capturePhoto,
                color: MeliColors.sea,
                icon: const Icon(Icons.camera_alt_outlined),
              ),
            ],
          ),
          MeliFloatingActionButton(
              icon: Icon(Icons.check),
              disabled: this.images.isEmpty,
              backgroundColor: MeliColors.electric,
              onPressed: this._createSighting),
        ],
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [MeliColors.electric, MeliColors.magnolia])),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                top: 20.0, bottom: 75.0, left: 20.0, right: 20.0),
            child: Wrap(
              runSpacing: 20.0,
              children: [
                images.isEmpty
                    ? ImageCarousel(imagePaths: [PLACEHOLDER_IMG])
                    : ImageCarousel(
                        imagePaths: images.map((file) => file.path).toList(),
                        onDelete: _onImageDelete),
                SimpleCard(
                    title: t.localNameCardTitle,
                    child: LocalNameAutocomplete(
                      onChanged: (AutocompleteItem result) {
                        if (result.value.isEmpty) {
                          localName = null;
                        } else {
                          localName = result;
                        }
                      },
                    )),
                LocationTrackerInput(onPositionChanged: (position) {
                  if (position == null) {
                    latitude = 0.0;
                    longitude = 0.0;
                  } else {
                    latitude = position.latitude;
                    longitude = position.longitude;
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

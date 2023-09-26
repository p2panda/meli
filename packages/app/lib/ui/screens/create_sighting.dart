// SPDX-License-Identifier: AGPL-3.0-or-later

// TODO: not used at the moment.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:app/router.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/scaffold.dart';
import 'package:app/models/sightings.dart';
import 'package:app/utils/camera.dart';

class CreateNewScreen extends StatefulWidget {
  CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameInput = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    getImage(ImageSource.camera).then((image) => {
          setState(() {
            _image = image;
          })
        });
  }

  @override
  void dispose() {
    nameInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MeliScaffold(
        title: 'Create new',
        floatingActionButtons: [
          MeliFloatingActionButton(
              heroTag: 'create_new',
              icon: Icon(Icons.create),
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
        body: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameInput,
                      decoration: const InputDecoration(
                        hintText: 'Local Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.image),
                            onPressed: () async {
                              File image = await getImage(ImageSource.gallery);
                              setState(() {
                                _image = image;
                              });
                            }),
                        IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: () async {
                            File image = await getImage(ImageSource.camera);
                            setState(() {
                              _image = image;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_image != null)
                      Container(
                          height: 400,
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )),
                  ],
                ))));
  }
}

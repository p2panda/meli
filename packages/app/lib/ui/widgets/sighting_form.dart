// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/widgets/image_provider.dart';
import 'package:app/ui/widgets/image_carousel.dart';

const String PLACEHOLDER_IMG = 'assets/images/placeholder-bee.png';

class CreateSightingForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const CreateSightingForm({super.key, required this.formKey});

  @override
  State<CreateSightingForm> createState() => _CreateSightingFormState();
}

class _CreateSightingFormState extends State<CreateSightingForm> {
  final nameInput = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraImageProvider = MeliCameraProviderInherited.of(context);
    final images = cameraImageProvider.getAll().map((file) {
      return Image.file(file);
    });

    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Form(
                key: this.widget.formKey,
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
                    cameraImageProvider.isEmpty()
                        ? ImageCarousel(images: [Image.asset(PLACEHOLDER_IMG)])
                        : ImageCarousel(
                            images: images.toList(),
                            onDelete: (int index) {
                              cameraImageProvider.removeAt(index);
                            })
                  ],
                ))));
  }
}

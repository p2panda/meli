// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'image_provider.dart';

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
                    SightingImagesCarousel()
                  ],
                ))));
  }
}

class SightingImagesCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cameraImageProvider = MeliCameraProviderInherited.of(context);
    final showDelete = !cameraImageProvider.isEmpty();
    final images = !cameraImageProvider.isEmpty()
        ? cameraImageProvider.getAll().map((file) {
            return Image.file(file);
          })
        : [Image.asset(PLACEHOLDER_IMG)];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: CarouselSlider(
        options: CarouselOptions(
            height: 200.0,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            padEnds: false,
            enlargeCenterPage: true),
        items: images.indexed.map((item) {
          return Builder(
            builder: (BuildContext context) {
              int index = item.$1;
              Image image = item.$2;
              return CarouselItem(
                  image: image, index: index, showDelete: showDelete);
            },
          );
        }).toList(),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem(
      {super.key,
      required this.image,
      required this.index,
      this.showDelete = false});

  final Image image;
  final int index;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    final cameraImageProvider = MeliCameraProviderInherited.of(context);

    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: MeliColors.pink,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            border: Border.all(width: 3, color: Colors.black)),
        child: Stack(children: [
          Container(
            alignment: Alignment.center,
            child: image,
          ),
          if (showDelete)
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[800]!),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder())),
                onPressed: () {
                  cameraImageProvider.removeAt(index);
                },
                child: Icon(
                  Icons.delete_outlined,
                  color: Colors.white,
                ),
              ),
            )
        ]));
  }
}

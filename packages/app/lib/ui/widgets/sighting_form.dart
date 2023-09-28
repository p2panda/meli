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
  const SightingImagesCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cameraImageProvider = MeliCameraProviderInherited.of(context);
    final images = cameraImageProvider.hasImages()
        ? cameraImageProvider.getImages().map((file) {
            return Image.file(file);
          })
        : [Image.asset(PLACEHOLDER_IMG)];

    return CarouselSlider(
      options: CarouselOptions(
          height: 200.0,
          enableInfiniteScroll: false,
          viewportFraction: 1,
          padEnds: false,
          enlargeCenterPage: true),
      items: images.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: MeliColors.pink,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Stack(children: [
                  Container(alignment: Alignment.center, child: image),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red[800]!),
                          shape: MaterialStateProperty.all<CircleBorder>(
                              CircleBorder(
                                  side: BorderSide(color: Colors.red[800]!)))),
                      onPressed: () {},
                      child: Icon(
                        Icons.delete_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ]));
          },
        );
      }).toList(),
    );
  }
}

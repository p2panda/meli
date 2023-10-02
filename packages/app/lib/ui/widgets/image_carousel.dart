// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:app/ui/colors.dart';

class ImageCarousel extends StatelessWidget {
  final List<Image> images;
  final Function? onDelete;

  ImageCarousel({super.key, required this.images, this.onDelete});

  @override
  Widget build(BuildContext context) {
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
                  image: image, index: index, onDelete: this.onDelete);
            },
          );
        }).toList(),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem(
      {super.key, required this.image, required this.index, this.onDelete});

  final Image image;
  final int index;
  final Function? onDelete;

  @override
  Widget build(BuildContext context) {
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
          if (this.onDelete != null)
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red[800]!),
                    shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder())),
                onPressed: () {
                  this.onDelete!(index);
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

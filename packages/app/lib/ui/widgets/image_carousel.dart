// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:app/ui/widgets/card.dart';
import 'package:app/ui/colors.dart';

typedef DeleteFunction = void Function(int);

class ImageCarousel extends StatefulWidget {
  final List<String> imagePaths;
  final DeleteFunction? onDelete;

  ImageCarousel({super.key, required this.imagePaths, this.onDelete});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  Widget _deleteButton() {
    return Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 10.0),
        child: CarouselButton(
            color: Colors.red,
            onPressed: () {
              this.widget.onDelete!(this._currentIndex);
            },
            icon: Icons.delete_outline));
  }

  Widget _previousButton() {
    return Container(
        alignment: Alignment.centerLeft,
        child: CarouselButton(
            color: Colors.transparent,
            onPressed: () {
              this._controller.previousPage(
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            },
            icon: Icons.navigate_before));
  }

  Widget _nextButton() {
    return Container(
        alignment: Alignment.centerRight,
        child: CarouselButton(
            color: Colors.transparent,
            onPressed: () {
              this._controller.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            },
            icon: Icons.navigate_next));
  }

  @override
  Widget build(BuildContext context) {
    return MeliCard(
      borderColor: MeliColors.black,
      borderWidth: 3.0,
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 200.0,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Stack(
          children: [
            CarouselSlider(
              carouselController: this._controller,
              options: CarouselOptions(
                  height: 200.0,
                  onPageChanged: (value, reason) {
                    setState(() {
                      this._currentIndex = value;
                    });
                  },
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  padEnds: false,
                  enlargeCenterPage: false),
              items: this.widget.imagePaths.map((path) {
                return CarouselItem(imagePath: path);
              }).toList(),
            ),
            if (this.widget.onDelete != null) this._deleteButton(),
            if (this._currentIndex > 0) this._previousButton(),
            if (this._currentIndex < this.widget.imagePaths.length - 1)
              this._nextButton(),
          ],
        ),
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  const CarouselItem({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    BoxFit fit = BoxFit.cover;
    double width = double.infinity;

    if (this.imagePath.contains('http')) {
      return Image.network(this.imagePath, fit: fit, width: width);
    } else if (this.imagePath.startsWith('/')) {
      return Image.file(File(this.imagePath), fit: fit, width: width);
    } else {
      return Image.asset(this.imagePath, fit: fit, width: width);
    }
  }
}

class CarouselButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final IconData icon;

  const CarouselButton(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: this.color, shape: CircleBorder()),
        onPressed: this.onPressed,
        child: Icon(this.icon, color: Colors.white));
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/colors.dart';
import 'package:app/models/blobs.dart';

class MeliImage extends StatelessWidget {
  final Blob? image;
  final String? externalError;

  MeliImage({super.key, required this.image, this.externalError});

  @override
  Widget build(BuildContext context) {
    if (this.externalError != null) {
      return ImageError(this.externalError!);
    }

    if (this.image == null) {
      return ImageError(AppLocalizations.of(context)!.imageMissingError);
    }

    return Image.network(
      'http://localhost:2020/blobs/${this.image!.id}',
      fit: BoxFit.cover,
      filterQuality: FilterQuality.low,
      frameBuilder: (BuildContext context, Widget child, int? frame,
          bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(color: MeliColors.black),
        );
      },
      errorBuilder: (context, error, stack) {
        return ImageError(AppLocalizations.of(context)!.imageLoadingError);
      },
    );
  }
}

class ImageError extends StatelessWidget {
  final String message;

  ImageError(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: MeliColors.peach,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.warning_rounded,
            size: 40.0,
            color: MeliColors.black,
          ),
          const SizedBox(height: 10.0),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge),
        ]));
  }
}

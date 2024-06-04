// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/io/files.dart';
import 'package:app/models/blobs.dart';
import 'package:app/ui/colors.dart';

class MeliImage extends StatelessWidget {
  final Blob? image;
  final String? externalError;

  const MeliImage({super.key, required this.image, this.externalError});

  Widget _error(BuildContext context, String message, IconData icon) {
    return Container(
        color: MeliColors.peach,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            icon,
            size: 40.0,
            color: MeliColors.black,
          ),
          const SizedBox(height: 10.0),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    if (externalError != null) {
      return _error(context, externalError!, Icons.warning_rounded);
    }

    if (image == null) {
      return _error(context, AppLocalizations.of(context)!.imageMissingError,
          Icons.image_not_supported);
    }

    return Image.network(
      '$BLOBS_BASE_PATH/${image!.id}',
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
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
        return _error(context, AppLocalizations.of(context)!.imageLoadingError,
            Icons.warning_rounded);
      },
    );
  }
}

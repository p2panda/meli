// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/colors.dart';
import 'package:app/models/blobs.dart';

class MeliImage extends StatelessWidget {
  final Blob? image;

  MeliImage({super.key, required this.image});

  Widget _error(BuildContext context, String message) {
    return Container(
        color: MeliColors.peach,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.warning_rounded,
            size: 40.0,
            color: MeliColors.black,
          ),
          SizedBox(height: 10.0),
          Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    if (this.image == null) {
      return this
          ._error(context, AppLocalizations.of(context)!.imageMissingError);
    }

    return Image.network(
      'http://localhost:2020/blobs/${this.image!.id}',
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
        return Center(
          child: CircularProgressIndicator(color: MeliColors.black),
        );
      },
      errorBuilder: (context, error, stack) {
        return this
            ._error(context, AppLocalizations.of(context)!.imageLoadingError);
      },
    );
  }
}

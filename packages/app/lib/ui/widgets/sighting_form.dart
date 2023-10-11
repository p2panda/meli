// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/widgets/image_carousel.dart';
import 'package:app/ui/widgets/image_provider.dart';
import 'package:app/ui/widgets/local_name_autocomplete.dart';
import 'package:app/ui/widgets/location_tracker.dart';
import 'package:app/ui/widgets/simple_card.dart';

const String PLACEHOLDER_IMG = 'assets/images/placeholder-bee.png';

typedef DeleteFunction = void Function(int);

class CreateSightingForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<File> images;
  final DeleteFunction onDeleteImage;

  const CreateSightingForm(
      {super.key,
      required this.formKey,
      this.images = const [],
      required this.onDeleteImage});

  @override
  State<CreateSightingForm> createState() => _CreateSightingFormState();
}

class _CreateSightingFormState extends State<CreateSightingForm> {
  final nameInput = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MeliCameraProviderInherited.of(context)
        .retrieveLostData()
        .then((file) => {if (file != null) this.widget.images.add(file)});
  }

  void _onDelete(int imageIndex) {
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
              this.widget.onDeleteImage(imageIndex);
              Navigator.pop(context);
            },
            child: Text(t.imageDeleteAlertConfirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: this.widget.formKey,
        child: Wrap(
          runSpacing: 20.0,
          children: [
            this.widget.images.isEmpty
                ? ImageCarousel(imagePaths: [PLACEHOLDER_IMG])
                : ImageCarousel(
                    imagePaths:
                        this.widget.images.map((file) => file.path).toList(),
                    onDelete: _onDelete),
            SimpleCard(title: 'Local Name', child: LocalNameAutocomplete()),
            LocationTrackerInput(onPositionChanged: (position) {
              if (position == null) {
                print('Position: n/a');
              } else {
                print('Position: $position');
              }
            }),
          ],
        ));
  }

  @override
  void dispose() {
    nameInput.dispose();
    super.dispose();
  }
}

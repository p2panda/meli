// SPDX-License-Identifier: AGPL-3.0-or-later

// TODO: not used at the moment.

import 'package:flutter/material.dart';

import 'package:app/models/sightings.dart';
import 'package:app/router.dart';
import 'package:app/ui/widgets/fab.dart';
import 'package:app/ui/widgets/scaffold.dart';

class CreateNewScreen extends StatefulWidget {
  CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameInput = TextEditingController();

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
                    await createSighting(nameInput.text);

                    // Go back to sightings overview
                    router.push(RoutePath.allSightings);

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
                        hintText: 'Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ],
                ))));
  }
}

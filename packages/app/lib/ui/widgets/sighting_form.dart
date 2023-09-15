// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:app/ui/widgets/card.dart';

class CreateSightingForm extends StatefulWidget {
  const CreateSightingForm({super.key});

  @override
  State<CreateSightingForm> createState() => _CreateSightingFormState();
}

class _CreateSightingFormState extends State<CreateSightingForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _speciesHasError = false;

  var speciesOptions = ['Melipolina', 'Melipolinio', 'Bumble Bee'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            // enabled: false,
            onChanged: () {
              _formKey.currentState!.save();
              debugPrint(_formKey.currentState!.value.toString());
            },
            autovalidateMode: AutovalidateMode.disabled,
            skipDisabled: true,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 15),
                MeliCard(
                  title: 'Species',
                  child: Container(
                    margin: EdgeInsets.all(4),
                    child: FormBuilderDropdown<String>(
                      name: 'species',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        suffix: _speciesHasError
                            ? const Icon(Icons.error)
                            : const Icon(Icons.check),
                        hintText: 'Select Species',
                      ),
                      borderRadius: BorderRadius.circular(12),
                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()]),
                      items: speciesOptions
                          .map((species) => DropdownMenuItem(
                        alignment: AlignmentDirectional.centerStart,
                        value: species,
                        child: Text(species),
                      ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _speciesHasError = !(_formKey
                              .currentState?.fields['species']
                              ?.validate() ??
                              false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      debugPrint(_formKey.currentState?.value.toString());
                    } else {
                      debugPrint(_formKey.currentState?.value.toString());
                      debugPrint('validation failed');
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _formKey.currentState?.reset();
                  },
                  // color: Theme.of(context).colorScheme.secondary,
                  child: Text(
                    'Reset',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

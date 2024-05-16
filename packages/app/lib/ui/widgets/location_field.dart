import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:app/ui/widgets/editable_card.dart';

class LocationField extends StatelessWidget {
  const LocationField({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return EditableCard(
        title: t.allSpeciesScreenTitle,
        onChanged: () {},
        child: const Text("test"));
  }
}

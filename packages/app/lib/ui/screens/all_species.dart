import 'package:flutter/material.dart';

import 'package:app/ui/widgets/scaffold.dart';

class AllSpeciesScreen extends StatefulWidget {
  AllSpeciesScreen({super.key});

  @override
  State<AllSpeciesScreen> createState() => _AllSpeciesScreenState();
}

class _AllSpeciesScreenState extends State<AllSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(title: 'Species');
  }
}

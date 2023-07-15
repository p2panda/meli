import 'package:flutter/material.dart';

import 'package:app/ui/widgets/scaffold.dart';

class CreateNewScreen extends StatefulWidget {
  CreateNewScreen({super.key});

  @override
  State<CreateNewScreen> createState() => _CreateNewScreenState();
}

class _CreateNewScreenState extends State<CreateNewScreen> {
  @override
  Widget build(BuildContext context) {
    return MeliScaffold(title: 'Create new');
  }
}

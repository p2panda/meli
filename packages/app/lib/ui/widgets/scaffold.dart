// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/material.dart';

import 'package:app/ui/colors.dart';

class MeliScaffold extends StatefulWidget {
  final String? title;
  final Widget? body;
  final Color backgroundColor;
  final Color appBarColor;
  final List<Widget> floatingActionButtons;
  final MainAxisAlignment fabAlignment;

  const MeliScaffold(
      {super.key,
      this.body,
      this.title,
      this.floatingActionButtons = const [],
      this.fabAlignment = MainAxisAlignment.spaceBetween,
      this.appBarColor = MeliColors.flurry,
      this.backgroundColor = MeliColors.flurry});

  @override
  State<MeliScaffold> createState() => _MeliScaffoldState();
}

class _MeliScaffoldState extends State<MeliScaffold> {
  AppBar? _appBar() {
    if (widget.title != null) {
      return AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 3.0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black54,
        forceMaterialTransparency: false,
        backgroundColor: widget.appBarColor,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          const SizedBox(width: 7.0),
          Text(widget.title!),
          const SizedBox(width: 35.0),
        ]),
      );
    }

    return null;
  }

  Widget? _floatingActionButtons() {
    if (widget.floatingActionButtons.isNotEmpty) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Row(
            mainAxisAlignment: widget.fabAlignment,
            children: widget.floatingActionButtons,
          ));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: _appBar(),
      body: widget.body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _floatingActionButtons(),
    );
  }
}

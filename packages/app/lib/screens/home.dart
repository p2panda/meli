import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({ super.key });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Hello, Meli!"));
  }
}
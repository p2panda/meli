import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:p2panda_flutter/p2panda_flutter.dart';

final p2panda = createLib();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Meli'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = "";

  void _generateEntry() async {
    final keyPair = await p2panda.newStaticMethodKeyPair();
    Uint8List bytes = await keyPair.publicKey();

    var operation = '''
      [
        1,
        0,
        "sightings_002048a55d9265a16ba44b5f3be3e457238e02d3219ecca777d7b4edf28ba2f6d011",
        {
          "name": "test"
        }
      ]
    ''';

    var operationBytes = await p2panda.encodeOperation(json: operation);
    var entryBytes = await p2panda.signAndEncodeEntry(logId: 0, seqNum: 1, payload: operationBytes, keyPair: keyPair);

    setState(() {
      _result = hex.encode(entryBytes) + "\n\n" + hex.encode(operationBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_result',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateEntry,
        tooltip: 'Generate Entry',
        child: const Icon(Icons.create),
      ),
    );
  }
}

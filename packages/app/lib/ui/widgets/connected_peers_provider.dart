// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:async';

import 'package:app/io/p2panda/p2panda.dart';
import 'package:p2panda/src/bridge_generated.dart';

import 'package:flutter/widgets.dart';

class ConnectedPeersProvider extends InheritedWidget {
  StreamSubscription<NodeEvent>? subscription;
  int _numPeers = 0;

  ConnectedPeersProvider({
    super.key,
    required super.child,
  });

  void _init() {
    if (subscription != null) {
      return;
    }

    p2panda.subscribeEventStream().listen((event) {
      print("$event");
      switch (event) {
        case NodeEvent.PeerConnected:
          _numPeers += 1;
          break;
        case NodeEvent.PeerDisconnected:
          _numPeers -= 1;
          break;
      }
    });
  }

  int getNumPeers() {
    _init();
    return _numPeers;
  }

  static ConnectedPeersProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ConnectedPeersProvider>()!;
  }

  @override
  bool updateShouldNotify(ConnectedPeersProvider oldWidget) {
    return _numPeers != oldWidget._numPeers;
  }
}

// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/ui/widgets/connected_peers_provider.dart';
import 'package:flutter/material.dart';

class ConnectedPeers extends StatefulWidget {
  const ConnectedPeers({super.key});

  @override
  State<ConnectedPeers> createState() => _ConnectedPeersState();
}

class _ConnectedPeersState extends State<ConnectedPeers> {
  @override
  Widget build(BuildContext context) {
    int numPeers = ConnectedPeersProvider.of(context).getNumPeers();
    return Text("$numPeers");
  }
}

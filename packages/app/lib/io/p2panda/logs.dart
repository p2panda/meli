// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:app/io/p2panda/p2panda.dart';

class Logger {
  Logger() {
    p2panda.subscribeLogStream().listen((logEntry) {
      print(logEntry.msg);
    });
  }
}

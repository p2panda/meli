// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:flutter/widgets.dart';

/// Actions which might affect other views.
enum RefreshKeys {
  CreatedSighting,
  UpdatedSighting,
  DeletedSighting,
  UpdatedSpecies,
  DeletedSpecies,
}

/// Global state keeping track of events where data was changed or created. This
/// is a way to inform widgets somewhere else in the app that they'll need to
/// reload data from the node and re-render as things have changed.
class RefreshProvider extends InheritedWidget {
  final Map<RefreshKeys, bool> _map = {};

  RefreshProvider({
    super.key,
    required super.child,
  });

  /// Flip dirty flag.
  void setDirty(RefreshKeys key) {
    _map[key] = true;
  }

  /// Returns status of "dirty" flag and flips it to false afterwards.
  bool isDirty(RefreshKeys key) {
    if (!_map.containsKey(key)) {
      return false;
    }

    bool status = _map[key]!;
    _map[key] = false;
    return status;
  }

  static RefreshProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshProvider>()!;
  }

  @override
  bool updateShouldNotify(RefreshProvider oldWidget) {
    return false;
  }
}

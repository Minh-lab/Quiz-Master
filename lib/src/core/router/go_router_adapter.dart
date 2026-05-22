import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterAdapter extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;
  GoRouterAdapter(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (_dynamic) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

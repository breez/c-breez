import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService {
  final _log = FimberLog("ConnectivityService");

  final StreamController<ConnectivityResult> _connectivityEventController =
      BehaviorSubject<ConnectivityResult>();

  Stream<ConnectivityResult> get connectivityEventStream =>
      _connectivityEventController.stream;

  final StreamController<bool> _c10yDialogEventController =
      BehaviorSubject<bool>();

  Stream<bool> get c10yDialogEventStream => _c10yDialogEventController.stream;

  Sink<bool> get c10yDialogEventSink => _c10yDialogEventController.sink;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  ConnectivityService() {
    c10yDialogEventSink.add(false);
    Timer(const Duration(seconds: 2), listen);
  }

  void listen() async {
    checkConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> checkConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      rethrow;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(
      ConnectivityResult connectionStatus) async {
    _connectivityEventController.add(connectionStatus);
  }

  close() {
    _connectivitySubscription.cancel();
    _connectivityEventController.close();
  }
}

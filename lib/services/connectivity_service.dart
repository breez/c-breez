import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class ConnectivityService {
  final _log = FimberLog("ConnectivityService");

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final _connectivityEventController = BehaviorSubject<ConnectivityResult>();

  Stream<ConnectivityResult> get connectivityEventStream =>
      _connectivityEventController.stream;

  Sink<ConnectivityResult> get _connectivityEventSink =>
      _connectivityEventController.sink;

  ConnectivityService() {
    Timer(const Duration(seconds: 4), listen);
  }

  void listen() async {
    await checkConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> checkConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      _log.e("Failed to check connectivity: $e");
      rethrow;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(
      ConnectivityResult connectionStatus) async {
    _log.i("Connection status changed to: ${connectionStatus.name}");
    if (connectionStatus != ConnectivityResult.none) {
      bool isDeviceConnected = await isConnected();
      if (!isDeviceConnected) {
        _connectivityEventSink.add(ConnectivityResult.none);
        return;
      }
    }
    _connectivityEventSink.add(connectionStatus);
  }

  Future<bool> isConnected() async {
    try {
      List<InternetAddress> result =
          await InternetAddress.lookup('scheduler.gl.blckstrm.com')
              .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        _log.e("Connection has no internet access");
        return false;
      }
    } on SocketException catch (e) {
      _log.e("Socket operation failed: ${e.message}");
      return false;
    }
  }

  close() {
    _connectivitySubscription.cancel();
    _connectivityEventController.close();
  }
}

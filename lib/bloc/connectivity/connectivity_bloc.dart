import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConnectivityBloc extends Cubit<ConnectivityResult?> {
  final _log = FimberLog("ConnectivityBloc");

  final Connectivity _connectivity = Connectivity();

  ConnectivityBloc() : super(null) {
    _checkConnectivity();
    _watchConnectivityChanges()
        .listen((connectivityResult) => emit(connectivityResult));
  }

  Stream<ConnectivityResult> _watchConnectivityChanges() {
    return _connectivity.onConnectivityChanged
        .asyncMap((status) async => await _updateConnectionStatus(status));
  }

  void _checkConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      _log.e("Failed to check connectivity: $e");
      rethrow;
    }
    emit(await _updateConnectionStatus(result));
  }

  Future<ConnectivityResult> _updateConnectionStatus(
      ConnectivityResult connectionStatus) async {
    _log.i("Connection status changed to: ${connectionStatus.name}");
    if (connectionStatus != ConnectivityResult.none) {
      bool isDeviceConnected = await _isConnected();
      if (!isDeviceConnected) {
        return connectionStatus;
      }
    }
    return connectionStatus;
  }

  Future<bool> _isConnected() async {
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
}

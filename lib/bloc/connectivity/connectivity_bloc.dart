import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'connectivity_state.dart';

class ConnectivityBloc extends Cubit<ConnectivityState> {
  final _log = FimberLog("ConnectivityBloc");

  final Connectivity _connectivity = Connectivity();

  ConnectivityBloc() : super(ConnectivityState()) {
    checkConnectivity();
    _watchConnectivityChanges()
        .listen((status) => emit(ConnectivityState(lastStatus: status)));
  }

  Stream<ConnectivityResult> _watchConnectivityChanges() {
    return _connectivity.onConnectivityChanged
        .asyncMap((status) async => await _updateConnectionStatus(status));
  }

  void checkConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _updateConnectionStatus(
          await _connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      _log.e("Failed to check connectivity: $e");
      rethrow;
    }
    emit(ConnectivityState(lastStatus: result));
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

  void addIsConnectingState() async {
    emit(ConnectivityState(lastStatus: state.lastStatus, isConnecting: true));
  }
}
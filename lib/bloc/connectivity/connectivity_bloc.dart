import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import 'connectivity_state.dart';

class ConnectivityBloc extends Cubit<ConnectivityState> {
  final _log = Logger("ConnectivityBloc");

  final Connectivity _connectivity = Connectivity();

  ConnectivityBloc() : super(ConnectivityState()) {
    checkConnectivity();
    _watchConnectivityChanges().listen((status) => emit(ConnectivityState(lastStatus: status)));
  }

  Stream<List<ConnectivityResult>> _watchConnectivityChanges() {
    return _connectivity.onConnectivityChanged.asyncMap(
      (status) async => await _updateConnectionStatus(status),
    );
  }

  Future<ConnectivityState> checkConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _updateConnectionStatus(await _connectivity.checkConnectivity());
    } on PlatformException catch (e) {
      _log.severe("Failed to check connectivity", e);
      rethrow;
    }
    final connectivityState = ConnectivityState(lastStatus: result);
    emit(connectivityState);
    return connectivityState;
  }

  Future<List<ConnectivityResult>> _updateConnectionStatus(List<ConnectivityResult> connectionResult) async {
    _log.info("Connection status changed to: $connectionResult");
    if (!connectionResult.contains(ConnectivityResult.none)) {
      bool isDeviceConnected = await _isConnected();
      if (!isDeviceConnected) {
        return connectionResult;
      }
    }
    return connectionResult;
  }

  Future<bool> _isConnected() async {
    try {
      List<InternetAddress> result = await InternetAddress.lookup(
        'scheduler.gl.blckstrm.com',
      ).timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        _log.severe("Connection has no internet access");
        return false;
      }
    } on SocketException catch (e) {
      _log.severe("Socket operation failed", e);
      return false;
    }
  }

  void setIsConnecting(bool isConnecting) async {
    emit(ConnectivityState(lastStatus: state.lastStatus, isConnecting: isConnecting));
  }
}

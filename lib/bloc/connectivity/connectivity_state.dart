import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityState {
  final ConnectivityResult? lastStatus;
  final bool isConnecting;

  ConnectivityState({this.lastStatus, this.isConnecting = false});
}

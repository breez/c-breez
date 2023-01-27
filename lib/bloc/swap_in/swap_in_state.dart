import 'package:breez_sdk/bridge_generated.dart';

class SwapInState {
  final SwapInfo? inProgress;
  final SwapInfo? unused;
  final bool isLoading;
  final String? error;

  SwapInState(this.inProgress, this.unused, {this.isLoading=false, this.error});
}

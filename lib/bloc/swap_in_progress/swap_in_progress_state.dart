import 'package:breez_sdk/bridge_generated.dart';

class SwapInProgressState {
  final SwapInfo? inProgress;
  final SwapInfo? unused;
  final bool isLoading;
  final String? error;

  SwapInProgressState(this.inProgress, this.unused, {this.isLoading = false, this.error});
}

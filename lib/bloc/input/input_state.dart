import 'package:breez_sdk/sdk.dart';

class InputState {
  final InputProtocol? protocol;
  final dynamic inputData;
  final bool isLoading;

  InputState({
    this.protocol,
    this.inputData,
    this.isLoading = false,
  });

  @override
  String toString() => 'InputState{protocol: $protocol, inputData: $inputData, isLoading: $isLoading}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InputState &&
          runtimeType == other.runtimeType &&
          protocol == other.protocol &&
          inputData == other.inputData &&
          isLoading == other.isLoading;

  @override
  int get hashCode => protocol.hashCode ^ inputData.hashCode ^ isLoading.hashCode;
}

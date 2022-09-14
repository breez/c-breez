import 'package:breez_sdk/sdk.dart';

class InputState {
  final InputProtocol? protocol;
  final dynamic inputData;
  final bool isLoading;

  InputState({this.protocol, this.inputData, this.isLoading = false});
}

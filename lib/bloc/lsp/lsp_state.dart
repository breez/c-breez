import 'package:breez_sdk/sdk.dart';

class LspState {
  final LspInformation? lspInfo;
  final String? selectedLspId;

  LspState({this.lspInfo, this.selectedLspId});

  // this returns true if the current LSP supports opening new channels.
  bool get isChannelOpeningAvailable {
    return (lspInfo != null) ? lspInfo!.openingFeeParamsList.values.isNotEmpty : false;
  }

  @override
  String toString() {
    return 'LspState{lspInfo: $lspInfo, selectedLspId: $selectedLspId}';
  }
}

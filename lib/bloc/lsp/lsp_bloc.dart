import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class LSPBloc extends Cubit<LspInformation?> {
  final BreezBridge _breezLib;

  LSPBloc(this._breezLib) : super(null) {
    // for every change in node state check if we have the current selected lsp as a peer.
    // If not instruct the sdk to connect.
    _breezLib.nodeStateStream
        .where((nodeState) => nodeState != null)
        .listen((nodeState) async {
      var activeLSP = await currentLSP;
      if (activeLSP != null) {
        if (!_isLspConnected(nodeState!.connectedPeers, activeLSP.pubkey)) {
          await connectLSP(activeLSP.id);
        }
        emit(activeLSP);
        return;
      }
    });
  }

  bool _isLspConnected(List<String> connectedPeers, String pubkey) =>
      connectedPeers.contains(pubkey);

  // connect to a specific lsp
  Future connectLSP(String lspID) async => await _breezLib.connectLSP(lspID);

  // fetch the connected lsp from the sdk.
  Future<LspInformation>? get currentLSP async => await _breezLib.getLspInfo();

  // fetch the lsp list from the sdk.
  Future<List<LspInformation>> get lspList async => await _breezLib.listLsps();
}

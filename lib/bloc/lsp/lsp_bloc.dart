import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'lsp_state.dart';

class LSPBloc extends Cubit<LspState?> {
  final BreezSDK _breezLib;
  NodeState? _nodeState;

  LSPBloc(this._breezLib) : super(null) {
    // for every change in node state check if we have the current selected lsp as a peer.
    // If not instruct the sdk to connect.
    _breezLib.nodeStateStream.where((nodeState) => nodeState != null).listen((nodeState) async {
      // emit first with the current selected lsp
      emit(LspState(selectedLspId: await _breezLib.lspId(), lspInfo: state?.lspInfo));
      _nodeState = nodeState;
      _refreshLspInfo();
    });

    Connectivity().onConnectivityChanged.listen((event) {
      // we should try fetch the selected lsp information when internet is back.
      if (event != ConnectivityResult.none && state?.lspInfo == null && state?.selectedLspId != null) {
        _refreshLspInfo();
      }
    });
  }

  // refresh the lsp information based on the current node id.
  // in addition try to connect to the lsp peer if we are not connected to the lsp.
  Future _refreshLspInfo() async {
    // in case we didn't get the initial node state we can't refresh.
    if (_nodeState == null) {
      return;
    }
    var activeLSP = await fetchCurrentLSP();
    if (activeLSP != null) {
      if (!_isLspConnected(_nodeState!.connectedPeers, activeLSP.pubkey)) {
        await connectLSP(activeLSP.id);
      }
      emit(LspState(selectedLspId: state?.selectedLspId, lspInfo: activeLSP));
      return;
    }

    emit(LspState(selectedLspId: null, lspInfo: null));
  }

  bool _isLspConnected(List<String> connectedPeers, String pubkey) => connectedPeers.contains(pubkey);

  // connect to a specific lsp
  Future connectLSP(String lspID) async => await _breezLib.connectLSP(lspID);

  // fetch the connected lsp from the sdk.
  Future<LspInformation?> fetchCurrentLSP() async {
    if (state?.selectedLspId == null) {
      return null;
    }
    return await _breezLib.fetchLspInfo(state!.selectedLspId!);
  }

  // fetch the lsp list from the sdk.
  Future<List<LspInformation>> get lspList async => await _breezLib.listLsps();
}

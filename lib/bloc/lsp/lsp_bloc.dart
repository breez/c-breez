import 'dart:async';
import 'package:breez_sdk/breez_bridge.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:breez_sdk/sdk.dart' as breez_sdk;

import 'lsp_state.dart';

class LSPBloc extends Cubit<LSPState> with HydratedMixin {  
  final breez_sdk.LightningNode _lightningNode;
  final BreezBridge breezLib;
  String? nodeID;
  bool _lspFetched = false;

  LSPBloc(this._lightningNode, this.breezLib) : super(LSPState.initial()) {
    if (state.connectionStatus == LSPConnectionStatus.inProgress) {
      emit(state.copyWith(connectionStatus: LSPConnectionStatus.notActive));
    }
    
    // for every change in node state check if we have the current selected lsp as a peer.
    // If not instruct the sdk to connect.
    
    _lightningNode.nodeStateStream().where((nodeState) => nodeState != null).listen((nodeState) async {
      nodeID = nodeState!.id;
      fetchLSPList();
      if (state.currentLSP != null) {
        final shouldConnect = !nodeState.connectedPeers.contains(state.currentLSP!.pubkey);
        await _lightningNode.setLSP(state.currentLSP!, connect: shouldConnect);
        return;
      }      
    });    
  }

  // fetch the lsp list from the sdk.
  Future fetchLSPList() async {
    if (!_lspFetched) {
      try {
        emit(state.copyWith(availableLSPs: await breezLib.listLsps()));
        _lspFetched = true;
      } catch (e) {
        emit(state.copyWith(lastConnectionError: e.toString()));
      }
    }    
  }

  // connectd to a specific lsp
  Future connectLSP(String lspID) async {
    try {
      var lsp = state.availableLSPs.firstWhere((l) => l.id == lspID);
      emit(state.copyWith(connectionStatus: LSPConnectionStatus.inProgress, selectedLSP: lspID));
      await _lightningNode.setLSP(lsp, connect: true);
      emit(state.copyWith(connectionStatus: LSPConnectionStatus.active));
    } catch (e) {
      emit(LSPState.initial().copyWith(
          availableLSPs: state.availableLSPs,
          connectionStatus: LSPConnectionStatus.notSelected,
          lastConnectionError: e.toString()));
    }
  }

  @override
  LSPState fromJson(Map<String, dynamic> json) {
    return LSPState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(LSPState state) {
    return state.toJson();
  }
}

import 'dart:async';

import 'package:breez_sdk/breez_bridge.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'lsp_state.dart';

class LSPBloc extends Cubit<LSPState> with HydratedMixin {
  final BreezBridge _breezLib;
  String? nodeID;
  bool _lspFetched = false;

  LSPBloc(this._breezLib) : super(LSPState.initial()) {
    if (state.connectionStatus == LSPConnectionStatus.inProgress) {
      emit(state.copyWith(connectionStatus: LSPConnectionStatus.notActive));
    }

    // for every change in node state check if we have the current selected lsp as a peer.
    // If not instruct the sdk to connect.

    _breezLib.nodeStateStream
        .where((nodeState) => nodeState != null)
        .listen((nodeState) async {
      nodeID = nodeState!.id;
      fetchLSPList();
      if (state.currentLSP != null) {
        await _breezLib.setLspId(state.currentLSP!.id);
        return;
      }
    });
  }

  // fetch the lsp list from the sdk.
  Future fetchLSPList() async {
    if (!_lspFetched) {
      try {
        emit(state.copyWith(availableLSPs: await _breezLib.listLsps()));
        _lspFetched = true;
      } catch (e) {
        emit(state.copyWith(lastConnectionError: e.toString()));
      }
    }
  }

  // connect to a specific lsp
  Future connectLSP(String lspID) async {
    try {
      var lsp = state.availableLSPs.firstWhere((l) => l.id == lspID);
      emit(state.copyWith(
          connectionStatus: LSPConnectionStatus.inProgress,
          selectedLSP: lspID));
      await _breezLib.setLspId(lsp.id);
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

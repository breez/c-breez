import 'dart:async';

import 'package:c_breez/repositories/app_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:breez_sdk/sdk.dart' as lntoolkit;

import 'lsp_state.dart';

class LSPBloc extends Cubit<LSPState> with HydratedMixin {
  final AppStorage _appStorage;
  final lntoolkit.LightningNode _lightningNode;
  final lntoolkit.LSPService _lspService;
  String? nodeID;
  bool _lspFetched = false;

  LSPBloc(this._appStorage, this._lightningNode, this._lspService) : super(LSPState.initial()) {
    if (state.connectionStatus == LSPConnectionStatus.inProgress) {
      emit(state.copyWith(connectionStatus: LSPConnectionStatus.notActive));
    }
    
    // for every change in node state check if we have the current selected lsp as a peer.
    // If not instruct the sdk to connect.
    _appStorage.watchNodeState().where((nodeState) => nodeState != null).listen((nodeState) async {
      nodeID = nodeState!.nodeID;
      fetchLSPList();
      if (state.currentLSP != null) {
        final shouldConnect = !nodeState.connectedPeers.split(",").contains(state.currentLSP!.pubKey);
        await _lightningNode.setLSP(state.currentLSP!, connect: shouldConnect);
        return;
      }      
    });    
  }

  // fetch the lsp list from the sdk.
  Future fetchLSPList() async {
    if (nodeID == null) {
      throw Exception("node id is not initialized");
    }
    if (!_lspFetched) {
      try {
        var list = await _lspService.getLSPList(nodeID!);
        emit(state.copyWith(availableLSPs: list.values.toList()));
        _lspFetched = true;
      } catch (e) {
        emit(state.copyWith(lastConnectionError: e.toString()));
      }
    }    
  }

  // connectd to a specific lsp
  Future connectLSP(String lspID) async {
    try {
      var lsp = state.availableLSPs.firstWhere((l) => l.lspID == lspID);
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

import 'dart:async';

import 'package:c_breez/repositorires/app_storage.dart';
import 'package:c_breez/services/breez_server/server.dart';
import 'package:c_breez/services/lightning/interface.dart';
import 'package:c_breez/utils/retry.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'lsp_state.dart';

class LSPBloc extends Cubit<LSPState> with HydratedMixin {
  final AppStorage _appStorage;
  final LightningService _lnService;
  final BreezServer _breezServer;
  String? nodeID;

  LSPBloc(this._appStorage, this._lnService, this._breezServer) : super(LSPState.initial()) {
    emit(LSPState.initial());
    _appStorage.watchNodeInfo().where((node) => node != null).map((node) => node!.node.nodeID).distinct().listen((nodeID) {
      this.nodeID = nodeID;
      watchLSPState();
      fetchLSPList();
    });
  }

  Future fetchLSPList() async {
    if (nodeID == null) {
      throw Exception("node id is not initialized");
    }
    try {
      var list = await _breezServer.getLSPList(nodeID!);
      emit(state.copyWith(availableLSPs: list.values.toList(), initial: false));
    } catch (e) {
      emit(state.copyWith(lastConnectionError: e.toString(), initial: false));
    }
    // if (state.availableLSPs.length == 1) {
    //   connectLSP(state.availableLSPs[0].lspID);
    // }
  }

  Future connectLSP(String lspID) async {
    var lsp = state.availableLSPs.firstWhere((l) => l.lspID == lspID);
    emit(state.copyWith(connectionStatus: LSPConnectionStatus.inProgress, selectedLSP: lspID));
    try {
      await _lnService.waitReady();
      await retry(() async {
        await _lnService.connectPeer(lsp.pubKey, lsp.host);
        await _breezServer.openLSPChannel(lsp.lspID, nodeID!);
      }, tryLimit: 3, interval: const Duration(seconds: 2));
      emit(state.copyWith(connectionStatus: LSPConnectionStatus.active));
    } catch (e) {
      emit(LSPState.initial().copyWith(initial: false, availableLSPs: state.availableLSPs, connectionStatus: LSPConnectionStatus.notSelected, lastConnectionError: e.toString()));
    }
  }

  Future<String> waitCurrentNodeID() async {
    var nodeInfo =
        await _appStorage.watchNodeInfo().firstWhere((nodeInfo) => nodeInfo != null && nodeInfo.node.nodeID.isNotEmpty);
    return nodeInfo!.node.nodeID;
  }

  void watchLSPState() {
    _appStorage.watchPeers().listen((peers) async {
      if (this.state.connectionStatus == LSPConnectionStatus.inProgress) {
        return;
      }
      var state = this.state;
      var lspIndex = state.availableLSPs.indexWhere((l) => l.lspID == state.selectedLSP);
      if (state.selectedLSP != null) {
        // if the selected lsp is no longer in server list emit not active.
        if (lspIndex < 0) {
          emit(this
              .state
              .copyWith(connectionStatus: LSPConnectionStatus.notActive, lastConnectionError: "selected lsp not in list"));
        }

        var lsp = state.availableLSPs[lspIndex];
        var lspPeers = peers.where((p) => p.peer.peerId == lsp.lspID).toList();

        // if we don't have the lsp in one of our peers then emit not active.
        if (lspPeers.isEmpty || lspPeers[0].channels.isEmpty) {
          emit(this.state.copyWith(connectionStatus: LSPConnectionStatus.notActive, lastConnectionError: null));
        }
      }
    });
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

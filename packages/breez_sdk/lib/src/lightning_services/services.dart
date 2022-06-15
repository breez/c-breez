import 'dart:typed_data';

import 'package:breez_sdk/sdk.dart';

import 'btc_swapper.dart';
import 'node.dart';

class LightningServices {
  final NodeAPI _nodeAPI = Greenlight();  
  LightningNode? _lightningNode;
  BTCSwapper?  _btcSwapper;  

  Future<List<int>> newNodeFromSeed(Uint8List seed, Signer signer) async {
    final creds = await _nodeAPI.register(seed, signer);
    _initServices(signer);
    return creds;
  }

  Future<List<int>> connectWithSeed(Uint8List seed, Signer signer) async {
    final creds = await _nodeAPI.recover(seed, signer);
    _initServices(signer);
    return creds;
  }

  connectWithCredentials(List<int> credentials, Signer signer) {
    _nodeAPI.initWithCredentials(credentials, signer);
    _initServices(signer);
  }

  void _initServices(Signer signer) {    
    _lightningNode = LightningNode(_nodeAPI, signer, LSPService());
    _btcSwapper = BTCSwapper(_nodeAPI);
  }

  LightningNode getNodeService() {
    if (_lightningNode == null) {
      throw Exception("node API is not initialized");
    }
    return _lightningNode!;
  }

  BTCSwapper getBTCSwapperService() {
    if (_btcSwapper == null) {
      throw Exception("node API is not initialized");
    }
    return _btcSwapper!;
  }

  NodeAPI getNodeAPI() {
    return _nodeAPI;
  }
}

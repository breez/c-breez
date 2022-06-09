import 'dart:typed_data';

import 'package:breez_sdk/sdk.dart';

import 'btc_swapper.dart';
import 'node.dart';

class LightningServices {
  final NodeAPI _nodeAPI = Greenlight();

  Future<List<int>> newNodeFromSeed(Uint8List seed, Signer signer) {
    return _nodeAPI.register(seed, signer);
  }

  Future<List<int>> connectWithSeed(Uint8List seed, Signer signer) {
    return _nodeAPI.recover(seed, signer);
  }

  connectWithCredentials(List<int> credentials, Signer signer) {
    _nodeAPI.initWithCredentials(credentials, signer);
  }

  LightningNode getNodeService() {
    return LightningNode(_nodeAPI);
  }

  BTCSwapper getBTCSwapperService() {
    return BTCSwapper(_nodeAPI);
  }

  NodeAPI getNodeAPI() {
    return _nodeAPI;
  }
}

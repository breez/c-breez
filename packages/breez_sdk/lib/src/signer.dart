import 'dart:typed_data';
import '../bridge_generated.dart';
import 'native_toolkit.dart';

class Signer {
  final Uint8List privateKey;
  final String storagePath;
  final _lnToolkit = getNativeToolkit();

  Signer(this.privateKey, this.storagePath);

  Future<Uint8List> init() {
    return _lnToolkit.initHsmd(storagePath: storagePath, secret: privateKey);
  }

  Future<Uint8List> signMessage({required Uint8List message}) {
    return _lnToolkit.signMessage(storagePath: storagePath, secret: privateKey, msg: message);
  }

  Future<Uint8List> handle({required Uint8List message, Uint8List? peerId, required int dbId}) async {    
    return _lnToolkit.handle(storagePath: storagePath, secret: privateKey, msg: message, peerId: peerId, dbId: dbId);
  }

  Future<String> addRoutingHints({required String invoice, required List<RouteHint> hints, required int newAmount, dynamic hint}) {
    return _lnToolkit.addRoutingHints(storagePath: storagePath, secret: privateKey, invoice: invoice, hints: hints, newAmount: newAmount);
  }

  Future<Uint8List> getNodePubkey() {
    return _lnToolkit.nodePubkey(storagePath: storagePath, secret: privateKey);
  }
}

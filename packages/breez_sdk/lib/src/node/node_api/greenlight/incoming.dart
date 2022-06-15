

import 'dart:typed_data';
import 'package:breez_sdk/src/signer.dart';
import 'package:fimber/fimber.dart';
import 'package:hex/hex.dart';
import './generated/greenlight.pbgrpc.dart' as greenlight;

import '../models.dart';
import 'service.dart';

class SignerLoop {
  final Signer _signer;
  final greenlight.NodeClient _nodeClient;
  final _log = FimberLog("SignerLoop");

  SignerLoop(this._signer, this._nodeClient);

  Future start() {
    return _nodeClient.streamHsmRequests(greenlight.Empty()).listen((value) async {
        var msg = HEX.encode(value.raw);        
        _log.i(
            "hsmd raw: $msg requestId: ${value.requestId} peer_id: ${HEX.encode(value.context.nodeId)} dbId: ${value.context.dbid.toInt()}");

        try {          
          var result = await _signer.handle(
              message: Uint8List.fromList(value.raw),
              peerId: value.context.nodeId.length == 33 ? Uint8List.fromList(value.context.nodeId) : null,
              dbId: value.context.dbid.toInt());
          _log.i("hsmd message signed successfully");
          await _nodeClient.respondHsmRequest(greenlight.HsmResponse(requestId: value.requestId, raw: result.toList()));
          _log.i("hsmd message replied successfully");
        } catch (e) {
          _log.e("failed to handle hsmd message: ${e.toString()}", ex: e);
        }
      }).asFuture();
  }
}

class IncomingPaymentsLoop {
  final greenlight.NodeClient _nodeClient;
  final Sink<IncomingLightningPayment> _incomingPaymentsSink;

  IncomingPaymentsLoop(this._nodeClient, this._incomingPaymentsSink);

  Future start() {
    return _nodeClient
          .streamIncoming(greenlight.StreamIncomingFilter())
          .map((p) => IncomingLightningPayment(
              label: p.offchain.label,
              preimage: HEX.encode(p.offchain.preimage),
              amountMsats: amountToMSats(p.offchain.amount),
              paymentHash: HEX.encode(p.offchain.paymentHash),
              bolt11: p.offchain.bolt11,
              extratlvs: p.offchain.extratlvs.map((t) => TlvField(type: t.type.toInt(), value: HEX.encode(t.value))).toList()))
          .listen(_incomingPaymentsSink.add).asFuture();
  }
}


import 'dart:typed_data';

import 'package:c_breez/logger.dart';
import 'package:c_breez/services/lightning/models.dart';
import 'package:hex/hex.dart';
import 'package:lightning_toolkit/signer.dart';
import 'package:greenlight/generated/greenlight.pbgrpc.dart' as greenlight;

import 'service.dart';

class SignerLoop {
  final Signer _signer;
  final greenlight.NodeClient _nodeClient;

  SignerLoop(this._signer, this._nodeClient);

  Future start() {
    return _nodeClient.streamHsmRequests(greenlight.Empty()).listen((value) async {
        var msg = HEX.encode(value.raw);        
        log.info(
            "hsmd raw: $msg requestId: ${value.requestId} peer_id: ${HEX.encode(value.context.nodeId)} dbId: ${value.context.dbid.toInt()}");

        try {          
          var result = await _signer.handle(
              message: Uint8List.fromList(value.raw),
              peerId: value.context.nodeId.length == 33 ? Uint8List.fromList(value.context.nodeId) : null,
              dbId: value.context.dbid.toInt());
          log.info("hsmd message signed successfully");
          await _nodeClient.respondHsmRequest(greenlight.HsmResponse(requestId: value.requestId, raw: result.toList()));
          log.info("hsmd message replied successfully");
        } catch (e) {
          log.severe("failed to handle hsmd message: ${e.toString()}");
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
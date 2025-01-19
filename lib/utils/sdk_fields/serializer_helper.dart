import 'package:breez_sdk/sdk.dart';

/// Temporary toString implementations for SDK fields
String swapInfoToString(SwapInfo? swapInfo) {
  return (swapInfo == null)
      ? ""
      : "SwapInfo { bitcoinAddress: ${swapInfo.bitcoinAddress}, createdAt: ${swapInfo.createdAt}, lockHeight:"
          " ${swapInfo.lockHeight}, paymentHash: ${swapInfo.paymentHash}, preimage: ${swapInfo.preimage}, "
          "privateKey: ${swapInfo.privateKey}, publicKey: ${swapInfo.publicKey}, swapperPublicKey: ${swapInfo.swapperPublicKey}, "
          "script: ${swapInfo.script}, bolt11: ${swapInfo.bolt11}, paidMsat: ${swapInfo.paidMsat}, totalIncomingTxs: ${swapInfo.totalIncomingTxs}, "
          "confirmedSats: ${swapInfo.confirmedSats}, unconfirmedSats: ${swapInfo.unconfirmedSats}, status: ${swapInfo.status}, "
          "refundTxIds: ${swapInfo.refundTxIds}, unconfirmedTxIds: ${swapInfo.unconfirmedTxIds}, minAllowedDeposit: ${swapInfo.minAllowedDeposit}, "
          "maxAllowedDeposit: ${swapInfo.maxAllowedDeposit}, lastRedeemError: ${swapInfo.lastRedeemError}, channelOpeningFees: ${ofpToString(swapInfo.channelOpeningFees)}, "
          "confirmedAt: ${swapInfo.confirmedAt} }";
}

String ofpToString(OpeningFeeParams? ofp) {
  return (ofp == null)
      ? ""
      : "OpeningFeeParams { minMsat: ${ofp.minMsat}, minMsat: ${ofp.minMsat}, "
          "proportional: ${ofp.proportional}, validUntil: ${ofp.validUntil}, maxIdleTime: ${ofp.maxIdleTime}, "
          "maxIdleTime: ${ofp.maxIdleTime}, maxClientToSelfDelay: ${ofp.maxClientToSelfDelay}, promise: ${ofp.promise} }";
}

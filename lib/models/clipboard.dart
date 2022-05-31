enum ClipboardDataType {
  unrecognized,
  lnurl,
  nodeID,
  lightningAddress,
  paymentRequest,
}

class DecodedClipboardData {
  final String? data;
  final ClipboardDataType type;

  const DecodedClipboardData({
    this.data,
    this.type = ClipboardDataType.unrecognized,
  });

  DecodedClipboardData.unrecognized() : this();
}

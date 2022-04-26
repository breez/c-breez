

enum ClipboardDataType {unrecognized, lnurl, nodeID, lightningAddress, payamentRequest}

class DecodedClipboardData {
  String? data;
  ClipboardDataType type;

  DecodedClipboardData({this.data, this.type=ClipboardDataType.unrecognized});

  DecodedClipboardData.unrecognized(): this();
}

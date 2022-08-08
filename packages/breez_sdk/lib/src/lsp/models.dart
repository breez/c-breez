class LSPInfo {
  final String lspID;
  final String name;
  final String? widgetURL;
  final String pubKey;
  final List<int> lspPubkey;
  final String host;
  final bool frozen;
  final int minHtlcMsat;
  final int targetConf;
  final int timeLockDelta;
  final int baseFeeMsat;
  final int channelCapacity;
  final int channelFeePermyriad;
  final int maxInactiveDuration;
  final int channelMinimumFeeMsat;

  const LSPInfo({
    required this.lspID,
    required this.name,
    this.widgetURL,
    required this.pubKey,
    required this.lspPubkey,
    required this.host,
    this.frozen = false,
    required this.minHtlcMsat,
    required this.targetConf,
    required this.timeLockDelta,
    required this.baseFeeMsat,
    required this.channelCapacity,
    required this.channelFeePermyriad,
    required this.maxInactiveDuration,
    required this.channelMinimumFeeMsat,
  });

  Map toJson() => {
        'lspID': lspID,
        'name': name,
        'widgetURL': widgetURL,
        'pubKey': pubKey,
        'host': host,
        'frozen': frozen,
        'minHtlcMsat': minHtlcMsat,
        'targetConf': targetConf,
        'timeLockDelta': timeLockDelta,
        'baseFeeMsat': baseFeeMsat,
        'channelCapacity': channelCapacity,
        'channelFeePermyriad': channelFeePermyriad,
        'maxInactiveDuration': maxInactiveDuration,
        'channelMinimumFeeMsat': channelMinimumFeeMsat,
        'lspPubkey': lspPubkey,
      };

  factory LSPInfo.fromJson(Map<String, dynamic> json) {
    return LSPInfo(
      lspID: json["lspID"],
      name: json["name"],
      widgetURL: json["widgetURL"],
      pubKey: json["pubKey"],
      lspPubkey: (json["lspPubkey"] as List).cast(),
      host: json["host"],
      frozen: json["frozen"],
      minHtlcMsat: json["minHtlcMsat"],
      targetConf: json["targetConf"],
      timeLockDelta: json["timeLockDelta"],
      baseFeeMsat: json["baseFeeMsat"],
      channelCapacity: json["channelCapacity"],
      channelFeePermyriad: json["channelFeePermyriad"],
      maxInactiveDuration: json["maxInactiveDuration"],
      channelMinimumFeeMsat: json["channelMinimumFeeMsat"],
    );
  }
}

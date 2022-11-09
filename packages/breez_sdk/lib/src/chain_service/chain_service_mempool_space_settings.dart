import 'dart:convert';

class ChainServiceMempoolSpaceSettings {
  final String scheme;
  final String host;
  final String? port;

  const ChainServiceMempoolSpaceSettings({
    required this.scheme,
    required this.host,
    required this.port,
  });

  ChainServiceMempoolSpaceSettings copyWith({
    String? scheme,
    String? host,
    String? port,
  }) {
    return ChainServiceMempoolSpaceSettings(
      scheme: scheme ?? this.scheme,
      host: host ?? this.host,
      port: port ?? this.port,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "scheme": scheme,
      "host": host,
      "port": port,
    };
  }

  String mempoolUrl() => '$scheme://$host${port != null ? ":$port" : ""}';

  factory ChainServiceMempoolSpaceSettings.fromMap(Map<String, dynamic> map) {
    return ChainServiceMempoolSpaceSettings(
      scheme: map["scheme"] as String,
      host: map["host"] as String,
      port: map["port"] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChainServiceMempoolSpaceSettings.fromJson(String source) =>
      ChainServiceMempoolSpaceSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ChainServiceMempoolSpaceSettings.defaults() =>
      const ChainServiceMempoolSpaceSettings(scheme: "https", host: "mempool.space", port: null);

  @override
  String toString() => "ChainServiceMempoolSpaceSetting(scheme: $scheme, host: $host, port: $port)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChainServiceMempoolSpaceSettings &&
        other.scheme == scheme &&
        other.host == host &&
        other.port == port;
  }

  @override
  int get hashCode => scheme.hashCode ^ host.hashCode ^ port.hashCode;
}

const mempoolSpaceSettingsKey = "mempoolSpaceSettings";

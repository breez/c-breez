import 'dart:async';

import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import "package:ini/ini.dart";

class BreezServer {
  late CallOptions defaultCallOptions;
  late String openChannelToken;

  static Future<BreezServer> createWithDefaultConfig() async {
    String configString = await rootBundle.loadString('conf/breez.conf');
    Config config = Config.fromString(configString);
    return BreezServer(config);
  }

  BreezServer(Config config) {
    var lspToken = config.get("Application Options", "lsptoken");
      var metadata = <String, String>{};
      metadata["authorization"] = "Bearer $lspToken";
      defaultCallOptions =
          CallOptions(timeout: const Duration(seconds: 20), metadata: metadata);
      openChannelToken = config.get("Application Options", "openchanneltoken")!;
  }
  
  Future<ClientChannel> createServerChannel() async {
    String configString = await rootBundle.loadString('conf/breez.conf');
    Config config = Config.fromString(configString);
    var hostdetails =
        config.get("Application Options", "breezserver")?.split(':');
    if (hostdetails != null && hostdetails.length < 2) {
      hostdetails.add("443");
    }
    return ClientChannel(hostdetails![0],
        port: int.parse(hostdetails[1]),        
        options:
            const ChannelOptions(credentials: ChannelCredentials.secure()));
  }
}

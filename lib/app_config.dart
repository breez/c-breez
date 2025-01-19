import 'dart:convert';

import 'package:breez_sdk/sdk.dart';
import 'package:logging/logging.dart';

final _log = Logger("AppConfig");

class AppConfig {
  final String apiKey = const String.fromEnvironment("API_KEY");
  final String glCertificate = const String.fromEnvironment("GL_CERT");
  final String glKey = const String.fromEnvironment("GL_KEY");

  GreenlightCredentials? get partnerCredentials {
    try {
      return GreenlightCredentials(
        developerCert: base64.decode(glCertificate),
        developerKey: base64.decode(glKey),
      );
    } catch (e) {
      _log.warning("Failed to parse partner credentials: $e");
      return null;
    }
  }

  NodeConfig get nodeConfig {
    return NodeConfig_Greenlight(
      config: GreenlightNodeConfig(
        partnerCredentials: partnerCredentials,
      ),
    );
  }
}

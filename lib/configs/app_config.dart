import 'dart:convert';
import 'dart:typed_data';

import 'package:breez_sdk/sdk.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart';

final _log = Logger("AppConfig");

class AppConfig {
  final String apiKey = const String.fromEnvironment("API_KEY");

  /// Loads credentials asynchronously: first tries local assets, then env vars.
  Future<GreenlightCredentials?> get partnerCredentials async {
    return await _fromAssets() ?? _fromEnv();
  }

  Future<GreenlightCredentials?> _fromAssets() async {
    try {
      final certPem = await rootBundle.loadString("assets/gl-certs/client.crt");
      final keyPem = await rootBundle.loadString("assets/gl-certs/client-key.pem");
      return GreenlightCredentials(
        developerCert: Uint8List.fromList(utf8.encode(certPem)),
        developerKey: Uint8List.fromList(utf8.encode(keyPem)),
      );
    } catch (_) {
      _log.fine("Local certs not found in assets, falling back to env");
      return null;
    }
  }

  GreenlightCredentials? _fromEnv() {
    try {
      final certEnv = const String.fromEnvironment("GL_CERT");
      final keyEnv = const String.fromEnvironment("GL_KEY");

      // Detect Base64 (common for --dart-define) vs raw PEM
      Uint8List decode(String input) {
        try {
          return base64.decode(input);
        } catch (_) {
          return Uint8List.fromList(utf8.encode(input));
        }
      }

      return GreenlightCredentials(developerCert: decode(certEnv), developerKey: decode(keyEnv));
    } catch (e) {
      _log.warning("Failed to parse partner credentials: $e");
      return null;
    }
  }

  Future<NodeConfig> get nodeConfig async {
    final creds = await partnerCredentials;
    return NodeConfig_Greenlight(config: GreenlightNodeConfig(partnerCredentials: creds));
  }
}

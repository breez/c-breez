import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart';

enum LSPConnectionStatus { notSelected, inProgress, active, notActive }

class LSPState {
  final List<LspInformation> availableLSPs;
  final String? selectedLSP;
  final LSPConnectionStatus connectionStatus;
  final String? lastConnectionError;

  LSPState(
      {this.availableLSPs = const [],
      this.connectionStatus = LSPConnectionStatus.notSelected,
      this.selectedLSP,
      this.lastConnectionError});

  LSPState.initial() : this();

  LSPState copyWith({
    List<LspInformation>? availableLSPs,
    LSPConnectionStatus? connectionStatus,
    String? selectedLSP,
    String? lastConnectionError,
  }) {
    return LSPState(
        availableLSPs: availableLSPs ?? this.availableLSPs,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        selectedLSP: selectedLSP ?? this.selectedLSP,
        lastConnectionError: lastConnectionError ?? this.lastConnectionError);
  }

  factory LSPState.fromJson(Map<String, dynamic> jsonMap) {
    final List<LspInformation> availableLsps  = jsonDecode(jsonMap["availableLSPs"]);
    return LSPState(
      availableLSPs: availableLsps,
      connectionStatus: LSPConnectionStatus.values[jsonMap["connectionStatus"] as int],
      selectedLSP: jsonMap["selectedLSP"],
      lastConnectionError: jsonMap["lastConnectionError"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "availableLSPs": jsonEncode(availableLSPs),
      "connectionStatus": connectionStatus.index,
      "selectedLSP": selectedLSP,
      "lastConnectionError": lastConnectionError,
    };
  }

  bool get selectionRequired => selectedLSP == null && availableLSPs.isNotEmpty;

  LspInformation? get currentLSP {
    try {
      return availableLSPs.firstWhere((element) => element.id == selectedLSP);
    } catch(e) {
      return null;
    }
  }

  bool get hasLSP => currentLSP != null;
}

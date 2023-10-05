import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void setUpLogger() {
  Logger.root.level = Level.ALL;

  if (kDebugMode) {
    Logger.root.onRecord.listen((record) {
      print("[${record.loggerName}] {${record.level.name}} (${record.time}) : ${record.message}");
    });
  }
}

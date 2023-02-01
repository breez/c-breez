import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';

void setUpLogger() => Fimber.plantTree(UnitLogTree());

class UnitLogTree extends LogTree {
  @override
  List<String> getLevels() => ["V", "D", "I", "W", "E"];

  @override
  void log(
    String level,
    String message, {
    String? tag,
    Object? ex,
    StackTrace? stacktrace,
  }) {
    if (kDebugMode) {
      print("$tag [$level] $message");
      if (ex != null) print(ex);
      if (stacktrace != null) print(stacktrace);
    }
  }
}

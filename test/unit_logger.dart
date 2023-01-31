import 'package:fimber/fimber.dart';

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
    print("$tag [$level] $message");
    if (ex != null) print(ex);
    if (stacktrace != null) print(stacktrace);
  }
}

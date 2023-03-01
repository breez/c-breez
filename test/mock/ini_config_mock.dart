import 'package:ini/ini.dart' as ini;
import 'package:mockito/mockito.dart';

class IniConfigMock extends Mock implements ini.Config {
  final answers = <String, Map<String, String?>>{};

  @override
  String? get(String name, String option) {
    return answers[name]?[option];
  }
}

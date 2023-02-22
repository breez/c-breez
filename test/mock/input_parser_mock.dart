import 'package:breez_sdk/sdk.dart';
import 'package:mockito/mockito.dart';

class InputParserMock extends Mock implements InputParser {
  Map<String, ParsedInput> parseAnswer = {};

  @override
  Future<ParsedInput> parse(String s) async {
    return parseAnswer[s]!;
  }
}

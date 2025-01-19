import 'package:breez_translations/generated/breez_translations.dart';
import 'package:breez_translations/generated/breez_translations_en.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../unit_logger.dart';

void main() {
  setUpLogger();

  test('extractExceptionMessage should convert generic error to string', () {
    final message = extractExceptionMessage(Exception("Generic error"), _texts());
    expect(message, "Exception: Generic error");
  });
}

BreezTranslations _texts() => BreezTranslationsEn();

import 'package:c_breez/models/bug_report_behavior.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../unit_logger.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpLogger();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('mempool space url', () {
    test('default', () async {
      const preferences = Preferences();
      expect(await preferences.getMempoolSpaceUrl(), null);
    });

    test('set', () async {
      const preferences = Preferences();
      const url = "a mempool space url";
      await preferences.setMempoolSpaceUrl(url);
      expect(await preferences.getMempoolSpaceUrl(), url);
    });

    test('reset', () async {
      const preferences = Preferences();
      const url = "a mempool space url";
      await preferences.setMempoolSpaceUrl(url);
      await preferences.resetMempoolSpaceUrl();
      expect(await preferences.getMempoolSpaceUrl(), null);
    });
  });

  group('payment options proportional fee', () {
    test('default', () async {
      const preferences = Preferences();
      expect(await preferences.getPaymentOptionsProportionalFee(), kDefaultProportionalFee);
    });

    test('set', () async {
      const preferences = Preferences();
      await preferences.setPaymentOptionsProportionalFee(2.0);
      expect(await preferences.getPaymentOptionsProportionalFee(), 2.0);
    });
  });

  group('butg report behavior', () {
    test('default', () async {
      const preferences = Preferences();
      expect(await preferences.getBugReportBehavior(), BugReportBehavior.PROMPT);
    });

    test('set', () async {
      const preferences = Preferences();
      await preferences.setBugReportBehavior(BugReportBehavior.SEND_REPORT);
      expect(await preferences.getBugReportBehavior(), BugReportBehavior.SEND_REPORT);
    });
  });
}

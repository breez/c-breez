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
      final preferences = Preferences();
      expect(await preferences.getMempoolSpaceUrl(), null);
    });

    test('set', () async {
      final preferences = Preferences();
      const url = "a mempool space url";
      await preferences.setMempoolSpaceUrl(url);
      expect(await preferences.getMempoolSpaceUrl(), url);
    });

    test('reset', () async {
      final preferences = Preferences();
      const url = "a mempool space url";
      await preferences.setMempoolSpaceUrl(url);
      await preferences.resetMempoolSpaceUrl();
      expect(await preferences.getMempoolSpaceUrl(), null);
    });
  });

  group('payment options override fee', () {
    test('default', () async {
      final preferences = Preferences();
      expect(await preferences.getPaymentOptionsOverrideFeeEnabled(), kDefaultOverrideFee);
    });

    test('set', () async {
      final preferences = Preferences();
      await preferences.setPaymentOptionsOverrideFeeEnabled(true);
      expect(await preferences.getPaymentOptionsOverrideFeeEnabled(), true);
    });
  });

  group('payment options proportional fee', () {
    test('default', () async {
      final preferences = Preferences();
      expect(await preferences.getPaymentOptionsProportionalFee(), kDefaultProportionalFee);
    });

    test('set', () async {
      final preferences = Preferences();
      await preferences.setPaymentOptionsProportionalFee(2.0);
      expect(await preferences.getPaymentOptionsProportionalFee(), 2.0);
    });
  });
}

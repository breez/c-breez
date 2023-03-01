import 'package:c_breez/utils/preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('mempool space url', () async {
    final preferences = Preferences();
    const url = "a mempool space url";
    await preferences.setMempoolSpaceUrl(url);
    expect(await preferences.getMempoolSpaceUrl(), url);
  });

  test('mempool space url reset', () async {
    final preferences = Preferences();
    const url = "a mempool space fallback url";
    await preferences.setMempoolSpaceFallbackUrl(url);
    await preferences.resetMempoolSpaceUrl();
    expect(await preferences.getMempoolSpaceUrl(), isNull);
  });

  test('mempool space fallback url', () async {
    final preferences = Preferences();
    const url = "a mempool space fallback url";
    await preferences.setMempoolSpaceFallbackUrl(url);
    expect(await preferences.getMempoolSpaceFallbackUrl(), url);
  });
}

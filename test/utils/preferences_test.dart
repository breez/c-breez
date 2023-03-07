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
}

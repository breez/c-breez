import 'package:c_breez/utils/preferences.dart';
import 'package:mockito/mockito.dart';

class PreferencesMock extends Mock implements Preferences {
  @override
  Future<String?> getMempoolSpaceUrl() => Future<String?>.value("https://mempool.space/");

  @override
  Future<void> setMempoolSpaceUrl(String url) => Future<void>.value();

  @override
  Future<void> resetMempoolSpaceUrl() => Future<void>.value();
}

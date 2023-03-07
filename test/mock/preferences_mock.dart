import 'package:c_breez/utils/preferences.dart';
import 'package:mockito/mockito.dart';

class PreferencesMock extends Mock implements Preferences {
  String? mempoolSpaceUrl = "https://mempool.space/";

  @override
  Future<String?> getMempoolSpaceUrl() => Future<String?>.value(mempoolSpaceUrl);

  String? setMempoolSpaceUrlUrl;

  @override
  Future<void> setMempoolSpaceUrl(String url) {
    setMempoolSpaceUrlUrl = url;
    return Future<void>.value();
  }

  int resetMempoolSpaceUrlCalled = 0;

  @override
  Future<void> resetMempoolSpaceUrl() {
    resetMempoolSpaceUrlCalled++;
    return Future<void>.value();
  }
}

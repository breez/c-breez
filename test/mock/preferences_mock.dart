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

  String? mempoolSpaceFallbackUrl = "https://mempool.space/";

  @override
  Future<String?> getMempoolSpaceFallbackUrl() => Future<String?>.value(mempoolSpaceFallbackUrl);

  String? setMempoolSpaceFallbackUrlUrl;

  @override
  Future<void> setMempoolSpaceFallbackUrl(String url) {
    setMempoolSpaceFallbackUrlUrl = url;
    return Future<void>.value();
  }
}

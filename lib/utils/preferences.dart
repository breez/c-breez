import 'package:shared_preferences/shared_preferences.dart';

const String _mempoolSpaceUrlKey = "mempool_space_url";
const String _mempoolSpaceFallbackUrlKey = "mempool_space_url_fallback";

class Preferences {
  Future<String?> getMempoolSpaceUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mempoolSpaceUrlKey);
  }

  Future<void> setMempoolSpaceUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mempoolSpaceUrlKey, url);
  }

  Future<void> resetMempoolSpaceUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mempoolSpaceUrlKey);
  }

  Future<String?> getMempoolSpaceFallbackUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mempoolSpaceFallbackUrlKey);
  }

  Future<void> setMempoolSpaceFallbackUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mempoolSpaceFallbackUrlKey, url);
  }
}

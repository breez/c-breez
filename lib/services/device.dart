import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Device {
  final _clipboardController = BehaviorSubject<String>();
  Stream<String> get clipboardStream => _clipboardController.stream.where((e) => e != _lastFromAppClip);

  static const String LAST_CLIPPING_PREFERENCES_KEY = "lastClipping";
  static const String LAST_FROM_APP_CLIPPING_PREFERENCES_KEY = "lastFromAppClipping";

  String? _lastFromAppClip;

  Device() {
    var sharedPreferences = SharedPreferences.getInstance();
    sharedPreferences.then((preferences) {
      _lastFromAppClip = preferences.getString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY);
      _clipboardController.add(preferences.getString(LAST_CLIPPING_PREFERENCES_KEY) ?? "");
      fetchClipboard(preferences);
    });
    FGBGEvents.stream.where((event) => event == FGBGType.foreground).listen((event) async {
      fetchClipboard(await SharedPreferences.getInstance());
    });
    // TODO replace this pulling logic by a plugin (to be created) using the following native apis
    // https://developer.android.com/reference/android/content/ClipboardManager#addPrimaryClipChangedListener
    // https://developer.apple.com/documentation/uikit/uipasteboard/1622104-changednotification
    Stream.periodic(const Duration(seconds: 10)).listen((_) async {
      fetchClipboard(await SharedPreferences.getInstance());
    });
  }

  Future setClipboardText(String text) async {
    _lastFromAppClip = text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY, text);
    await Clipboard.setData(ClipboardData(text: text));
    fetchClipboard(prefs);
  }

  Future shareText(String text) {
    return Share.share(text);
  }

  void fetchClipboard(SharedPreferences preferences) {
    Clipboard.getData("text/plain").then((clipboardData) {
      final text = clipboardData?.text;
      if (text != null) {
        _clipboardController.add(text);
        preferences.setString(LAST_CLIPPING_PREFERENCES_KEY, text);
      }
    });
  }

  Future<String> appVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}.${packageInfo.buildNumber}";
  }
}

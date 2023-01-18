import 'dart:async';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = FimberLog("Device");

class Device extends ClipboardListener {
  final _clipboardController = BehaviorSubject<String>();
  Stream<String> get clipboardStream => _clipboardController.stream.where((e) => e != _lastFromAppClip);

  static const String LAST_CLIPPING_PREFERENCES_KEY = "lastClipping";
  static const String LAST_FROM_APP_CLIPPING_PREFERENCES_KEY = "lastFromAppClipping";

  String? _lastFromAppClip;

  Device() {
    _log.v("Initing Device");
    var sharedPreferences = SharedPreferences.getInstance();
    sharedPreferences.then((preferences) {
      _lastFromAppClip = preferences.getString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY);
      _clipboardController.add(preferences.getString(LAST_CLIPPING_PREFERENCES_KEY) ?? "");
      _log.v("Last clipping: $_lastFromAppClip");
      fetchClipboard(preferences);
    });
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();
  }

  Future setClipboardText(String text) async {
    _log.v("Setting clipboard text: $text");
    _lastFromAppClip = text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY, text);
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future shareText(String text) {
    _log.v("Sharing text: $text");
    return Share.share(text);
  }

  void fetchClipboard(SharedPreferences preferences) {
    _log.v("Fetching clipboard");
    Clipboard.getData("text/plain").then((clipboardData) {
      final text = clipboardData?.text;
      _log.v("Clipboard text: $text");
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

  @override
  void onClipboardChanged() {
    _log.v("Clipboard changed");
    SharedPreferences.getInstance().then((preferences) {
      fetchClipboard(preferences);
    });
  }
}

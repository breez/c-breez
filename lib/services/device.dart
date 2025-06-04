import 'dart:async';

import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _log = Logger("Device");

class DeviceClient extends ClipboardListener {
  final _clipboardController = BehaviorSubject<String>();
  Stream<String> get clipboardStream => _clipboardController.stream.where((e) => e != _lastFromAppClip);

  static const String LAST_CLIPPING_PREFERENCES_KEY = "lastClipping";
  static const String LAST_FROM_APP_CLIPPING_PREFERENCES_KEY = "lastFromAppClipping";

  String? _lastFromAppClip;

  DeviceClient() {
    _log.info("Initing Device");
    var sharedPreferences = SharedPreferences.getInstance();
    sharedPreferences.then((preferences) {
      _lastFromAppClip = preferences.getString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY);
      _clipboardController.add(preferences.getString(LAST_CLIPPING_PREFERENCES_KEY) ?? "");
      _log.info("Last clipping: $_lastFromAppClip");
      fetchClipboard(preferences);
    });
    clipboardWatcher.addListener(this);
    clipboardWatcher.start();
  }

  Future setClipboardText(String text) async {
    _log.info("Setting clipboard text: $text");
    _lastFromAppClip = text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(LAST_FROM_APP_CLIPPING_PREFERENCES_KEY, text);
    await Clipboard.setData(ClipboardData(text: text));
  }

  void fetchClipboard(SharedPreferences preferences) {
    _log.info("Fetching clipboard");
    Clipboard.getData("text/plain").then((clipboardData) {
      final text = clipboardData?.text;
      _log.info("Clipboard text: $text");
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

  /// Retrieves text from the device clipboard.
  ///
  /// Returns the clipboard text as a [String] or null if the clipboard is empty.
  Future<String?> fetchClipboardData() async {
    _log.info('Fetching clipboard data');
    try {
      final ClipboardData? clipboardData = await Clipboard.getData('text/plain');
      final String? text = clipboardData?.text;
      if (text != null) {
        _clipboardController.add(text);
        _log.fine('Updated clipboard stream with text');
      }
      _log.fine('Retrieved clipboard text: $text');
      return text;
    } catch (e) {
      _log.severe('Failed to fetch clipboard data', e);
      return null;
    }
  }

  @override
  void onClipboardChanged() {
    _log.info("Clipboard changed");
    SharedPreferences.getInstance().then((preferences) {
      fetchClipboard(preferences);
    });
  }
}

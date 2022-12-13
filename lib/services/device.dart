import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Device {
  final _clipboardController = BehaviorSubject<String>();
  Stream<String> get clipboardStream => _clipboardController.stream;

  static const String LAST_CLIPPING_PREFERENCES_KEY = "lastClipping";

  Device() {
    var sharedPreferences = SharedPreferences.getInstance();
    sharedPreferences.then((preferences) {
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
    await Clipboard.setData(ClipboardData(text: text));
    fetchClipboard(await SharedPreferences.getInstance());
  }

  Future shareText(String text) {
    return ShareExtend.share(text, "text");
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

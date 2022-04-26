import 'dart:async';

import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share_extend/share_extend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Device {  

  final _distinctClipboardController = BehaviorSubject<String>();
  Stream get distinctClipboardStream => _distinctClipboardController.stream;

  final _rawClipboardController = BehaviorSubject<String>();
  Stream<String> get rawClipboardStream => _rawClipboardController.stream;

  String _lastClipping = "";
  static const String LAST_CLIPPING_PREFERENCES_KEY = "lastClipping";

  Device() {
    var sharedPreferences = SharedPreferences.getInstance();
    sharedPreferences.then((preferences) {
      _lastClipping =
          preferences.getString(LAST_CLIPPING_PREFERENCES_KEY) ?? "";
      fetchClipboard(preferences);
    });    
  }

  Future setClipboardText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    fetchClipboard(await SharedPreferences.getInstance());
  }

  Future shareText(String text) {
    // if (defaultTargetPlatform == TargetPlatform.android) {
    //   return _breezShareChannel.invokeMethod("share", {"text": text});
    // }
    return ShareExtend.share(text, "text");
  }

  fetchClipboard(SharedPreferences preferences) {
    Clipboard.getData("text/plain").then((clipboardData) {
      if (clipboardData != null && clipboardData.text != null) {
        var text = clipboardData.text!;

        _rawClipboardController.add(text);
        if (text != _lastClipping) {
          _distinctClipboardController.add(text);
          preferences.setString(LAST_CLIPPING_PREFERENCES_KEY, text);
          _lastClipping = text;
        }
      }
    });
  }

  Future<String> appVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "${packageInfo.version}.${packageInfo.buildNumber}";
  }
}

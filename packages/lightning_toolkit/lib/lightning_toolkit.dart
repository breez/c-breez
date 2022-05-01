
import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

import 'bindings.dart';

class LightningToolkit {
  static const MethodChannel _channel = MethodChannel('lightning_toolkit');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void test() {
    final DynamicLibrary nativeExampleLib = Platform.isAndroid
      ? ffi.DynamicLibrary.open("liblightning_toolkit.so")   // Load the dynamic library on Android
      : ffi.DynamicLibrary.process();              // Load the static library on iOS
    var binding = LightningToolkitBindings(nativeExampleLib);
    const name = "Test";
    final ptrName = name.toNativeUtf8().cast<Int8>();    
    var resPtr = binding.test(ptrName);
    print(resPtr.cast<Utf8>().toDartString());
    binding.test_cstr_free(resPtr);
  }
}

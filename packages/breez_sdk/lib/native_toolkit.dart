import 'dart:ffi';
import 'dart:io';
import 'bridge_generated.dart';

LightningToolkit? _lightningToolkit;

LightningToolkit getNativeToolkit() {
  if (_lightningToolkit == null) {
    final DynamicLibrary lib = Platform.isAndroid
      ? DynamicLibrary.open("liblightning_toolkit.so")   // Load the dynamic library on Android
      : DynamicLibrary.process();
    _lightningToolkit = LightningToolkitImpl(lib);
  }
  return _lightningToolkit!;
}
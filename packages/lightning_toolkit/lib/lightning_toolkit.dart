
import 'dart:ffi';
import 'dart:io';

import 'package:lightning_toolkit/bridge_generated.dart';

LightningToolkit getLightningToolkit() {
  final DynamicLibrary lib = Platform.isAndroid
      ? DynamicLibrary.open("liblightning_toolkit.so")   // Load the dynamic library on Android
      : DynamicLibrary.process();
  return LightningToolkitImpl(lib);
}
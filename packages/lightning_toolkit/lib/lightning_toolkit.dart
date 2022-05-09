import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:lightning_toolkit/bridge_generated.dart';

LightningToolkit? _lightningToolkit;

LightningToolkit getLightningToolkit() {
  if (_lightningToolkit == null) {
    final DynamicLibrary lib = Platform.isAndroid
      ? DynamicLibrary.open("liblightning_toolkit.so")   // Load the dynamic library on Android
      : DynamicLibrary.process();
    _lightningToolkit = LightningToolkitImpl(lib);
  }
  return _lightningToolkit!;
}

class Signer {
  final Uint8List privateKey;

  Signer(this.privateKey);
  
  Future<Uint8List> handle({required Uint8List message, Uint8List? peerId, required int dbId}) async{
    return getLightningToolkit().handle(secret: privateKey, msg: message, peerId: peerId, dbId: dbId);
  }
}
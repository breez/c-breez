import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/utils.dart';
import 'package:bip32/src/utils/ecurve.dart' as ecc;
import 'package:crypto/crypto.dart' as crypto;
import 'package:convert/convert.dart';
import 'package:bip32/bip32.dart' as bip32;

Uint8List int32bytes(int value) =>
    Uint8List(4)..buffer.asInt32List()[0] = value;

Future<Uint8List> hdkf256(Uint8List s, String info) async {
  List<int> r = Uint8List.fromList([]);
  var salt = 0;
  var retry = true;
  do {
    try {
      final bip32Seed = await Hkdf(
        hmac: Hmac(Sha256()),
        outputLength: 32,
      ).deriveKey(
        secretKey: SecretKey(s),
        nonce: int32bytes(salt),
        info: info.codeUnits,
      );
      r = await bip32Seed.extractBytes();
      retry = false;
    } on UnsupportedError {
      salt++;
    }
  } while (retry);
  return Uint8List.fromList(r);
}

Future<HSMDCreds> hsmdInit(Uint8List secret) async {
  var bip32SeedBytes = await hdkf256(secret, 'bip32 seed');

  var testnet = bip32.NetworkType(
      bip32: bip32.Bip32Type(private: 0x04358394, public: 0x043587cf),
      wif: 0xef);
  var masterKey =
      bip32.BIP32.fromSeed(Uint8List.fromList(bip32SeedBytes), testnet);
  var secretBip32 = masterKey.derive(0).derive(0);

  var childKey = masterKey.deriveHardened(9735);

  var curve = ECCurve_secp256k1();

  var nodeidPrivateKeyBytes = await hdkf256(secret, 'nodeid');

  var nodeidPublic = ECPublicKey(
      curve.G * decodeBigIntWithSign(1, nodeidPrivateKeyBytes), curve);

  var initHex = 
      111.toRadixString(16).padLeft(4, '0') +
      hex.encode(nodeidPublic.Q!.getEncoded(true)) +
      secretBip32.network.bip32.public.toRadixString(16).padLeft(8, '0') +
      secretBip32.depth.toRadixString(16).padLeft(2, '0') +
      secretBip32.parentFingerprint.toRadixString(16).padLeft(8, '0') +
      secretBip32.index.toRadixString(16).padLeft(8, '0') +
      hex.encode(secretBip32.chainCode) +
      hex.encode(secretBip32.publicKey) +
      hex.encode(encodeBigIntAsUnsigned(ECPublicKey(
              curve.G * decodeBigIntWithSign(1, childKey.privateKey!), curve)
          .Q!
          .x!
          .toBigInteger()!));
  
  return HSMDCreds(nodeidPublic.Q!.getEncoded(true), nodeidPrivateKeyBytes, HEX.decode(initHex), secret);
}

Uint8List eccSign(Uint8List privateKey, Uint8List hash) {
  return ecc.sign(hash, privateKey);
}

Uint8List doubleHash(List<int> chal) {
  return Uint8List.fromList(crypto.sha256.convert(crypto.sha256.convert(chal).bytes).bytes);
}

class HSMDCreds {
  final List<int> nodeId;
  final List<int> nodePrivateKey;
  final List<int> init;
  final List<int> secret;

  HSMDCreds(this.nodeId, this.nodePrivateKey, this.init, this.secret);
}
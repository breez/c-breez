import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/utils.dart';
import 'package:basic_utils/basic_utils.dart';

class NodeInterceptor extends ClientInterceptor {
  ECPrivateKey? _privKey;

  NodeInterceptor(String privKeyPem) {
    _privKey = getPrivate(privKeyPem);
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
      ClientMethod<Q, R> method, Q request, CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
        
    // var body = frame(method.requestSerializer(request));
    // //var body = method.requestSerializer(request);
    // var signature = sign(frame(body), _privKey);
    // var publicKey = publicBase64(getPublic(_privKey));
    // print("body len = " + body.length.toString() + ":"  + base64.encode(body));
    // print(signature);
    // print(publicKey);

    //   //var glauthpubkey = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
    //  // var glauthsig = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));

    // var glauthpubkey = publicKey;
    // var glauthsig = signature;
    
    // var newOptions = options.mergedWith(CallOptions(metadata: {"glauthpubkey": glauthpubkey, "glauthsig": glauthsig}));
    return invoker(method, request, options);
  }

  ECPrivateKey getPrivate(String pemContent) {    
    var privateKey = CryptoUtils.ecPrivateKeyFromPem(pemContent);
    return privateKey;
  }

  ECPublicKey getPublic(ECPrivateKey privateKey) {
    ECPoint G = privateKey.parameters!.G;
    var Q = G * privateKey.d;
    return ECPublicKey(Q, privateKey.parameters);
  }

  String publicBase64(ECPublicKey ecPublicKey) {
    Uint8List buffer = Uint8List(65);
    buffer[0] = 4;
    buffer.setRange(1, 33, encodeBigIntAsUnsigned(ecPublicKey.Q!.x!.toBigInteger()!));
    buffer.setRange(33, 65, encodeBigIntAsUnsigned(ecPublicKey.Q!.y!.toBigInteger()!));
    //print(buffer);
    return base64Encode(buffer);
  }

  String sign(List<int> message, ECPrivateKey privateKey) {
    var signer = Signer('SHA-256/ECDSA') as ECDSASigner;
    SecureRandom random = SecureRandom('Fortuna');
    final _sGen = Random.secure();
    random.seed(KeyParameter(Uint8List.fromList(List.generate(32, (_) => _sGen.nextInt(255)))));
    signer.init(true, ParametersWithRandom(PrivateKeyParameter<ECPrivateKey>(privateKey), random));
    var toSign = Uint8List.fromList(message);
    var signature = signer.generateSignature(toSign) as ECSignature;
    //print(signature.r);
    //print(signature.s);
    Uint8List buffer = Uint8List(64);
    buffer.setRange(0, 32, encodeBigIntAsUnsigned(signature.r));
    buffer.setRange(32, 64, encodeBigIntAsUnsigned(signature.s));
    //print(buffer);
    return base64Encode(buffer);
  }
}

List<int> frame(List<int> rawPayload) {
  final compressedPayload = rawPayload;
  final payloadLength = compressedPayload.length;
  final bytes = Uint8List(payloadLength + 5);
  final header = bytes.buffer.asByteData(0, 5);
  header.setUint8(0, 0);
  header.setUint32(1, payloadLength);
  bytes.setRange(5, bytes.length, compressedPayload);
  return bytes;
}

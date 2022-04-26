import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:c_breez/services/lightning/greenlight/service.dart';
import 'package:bip39/bip39.dart' as bip39;

void main(List<String> arguments) async {
  var service = GreenlightService();
  var certsDir = Directory("certs");
  certsDir.createSync(recursive: true);
  var seedFile = File(p.join(certsDir.path, "secret_rust"));
  if (!seedFile.existsSync()) {
    var seed = bip39.mnemonicToSeed(bip39.generateMnemonic());
    seedFile.writeAsBytesSync(seed.getRange(0, 32).toList(), flush: true);
  }

  var seed = seedFile.readAsBytesSync();
  var credsFile = File(p.join(certsDir.path, "creds"));
  if (!credsFile.existsSync()) {
    var creds = await service.register(seed);
    credsFile.writeAsBytesSync(creds);
  }

  var creds = credsFile.readAsBytesSync();
  print("creds = " + String.fromCharCodes(creds));
  service.initWithCredentials(creds);
  await service.startNode();
  print("ok");
}

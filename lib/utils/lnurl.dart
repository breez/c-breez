import 'package:email_validator/email_validator.dart';
import 'package:fimber/fimber.dart';

String _lightningProtocolPrefix = "lightning:";
final _log = FimberLog("lnurl");

bool isLightningAddress(String uri) {
  var result = false;
  var v = parseLightningAddress(uri);
  result = v != null && v.isNotEmpty;
  return result;
}

String? parseLightningAddress(String? uri) {
  // Ref. https://github.com/andrerfneves/lightning-address/blob/master/DIY.md
  _log.i('parseLightningAddress: given "$uri"');

  String? result;
  if (uri != null && uri.isNotEmpty) {
    uri = uri.trim();
    var l = uri.toLowerCase();
    if (l.startsWith(_lightningProtocolPrefix)) {
      result = uri.substring(_lightningProtocolPrefix.length);
    }

    result ??= uri;
    if (!EmailValidator.validate(result)) {
      result = null;
    }
    _log.i('parseLightningAddress: got "$result"');
  }
  return result;
}

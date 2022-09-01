import 'package:c_breez/routes/lnurl/success_action_dialog.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

RegExp _lnurlPrefix = RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");

/// https://github.com/fiatjaf/lnurl-rfc/blob/luds/17.md
RegExp _lnurlRfc17Prefix = RegExp("(lnurl)(c|w|p)");
String _lightningProtocolPrefix = "lightning:";
final _log = FimberLog("lnurl");

bool isLNURL(String url) {
  var lower = url.toLowerCase();
  if (lower.startsWith(_lightningProtocolPrefix)) {
    lower = lower.substring(_lightningProtocolPrefix.length);
  }
  var firstMatch = _lnurlPrefix.firstMatch(lower);
  if (firstMatch != null && firstMatch.start == 0) {
    return true;
  }
  firstMatch = _lnurlRfc17Prefix.firstMatch(lower);
  if (firstMatch != null && firstMatch.start == 0) {
    return true;
  }
  try {
    Uri uri = Uri.parse(lower);
    String? lightning = uri.queryParameters["lightning"];
    return lightning != null &&
        (_lnurlPrefix.firstMatch(lightning) != null ||
            _lnurlRfc17Prefix.firstMatch(lightning) != null);
  } on FormatException {
    // do nothing.
  }
  return false;
}

bool isLightningAddress(String uri) {
  var result = false;
  var v = parseLightningAddress(uri);
  result = v != null && v.isNotEmpty;
  return result;
}

bool isLightningAddressURI(String uri) {
  var result = false;

  result = uri.toLowerCase().startsWith(_lightningProtocolPrefix) &&
      isLightningAddress(uri);
  return result;
}

parseLightningAddress(String? uri) {
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

String getSuccessActionMessage(
    LNURLPayResult lnurlPayResult, LNURLPaySuccessAction successAction) {
  switch (successAction.tag) {
    case 'aes':
      return decryptSuccessActionAesPayload(
        preimage: lnurlPayResult.pr,
        successAction: successAction,
      );
    case 'url':
      return successAction.description!;
    case 'message':
      return successAction.message!;
  }
  return '';
}

handleSuccessAction(BuildContext context, LNURLPayResult payResult) {
  LNURLPaySuccessAction successAction = payResult.successAction!;
  showDialog(
    useRootNavigator: false,
    context: context,
    builder: (_) => SuccessActionDialog(
      getSuccessActionMessage(payResult, successAction),
      url: successAction.url,
    ),
  );
}

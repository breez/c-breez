import 'package:dart_lnurl/dart_lnurl.dart';

import '../bridge_generated.dart';
import 'native_toolkit.dart';

class InputParser {
  final LightningToolkit _lnToolkit = getNativeToolkit();
  static RegExp lnurlPrefix = RegExp(",*?((lnurl)([0-9]{1,}[a-z0-9]+){1})");
  static RegExp lnurlRfc17Prefix = RegExp("(lnurl)(c|w|p)");

  Future<ParsedInput> parse(String s) async {
    // lightning link
    String lower = s.toLowerCase();
    if (lower.startsWith("lightning:")) {
      final invoice = await _lnToolkit.parseInvoice(invoice: s.substring(10));
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    }

    // lnurl
    if (lower.contains(lnurlPrefix)) {
      LNURLParseResult parseResult = await getParams(lower);
      if (parseResult.payParams != null) {
        return ParsedInput(InputProtocol.lnurlPay, lower);
      }
      if (parseResult.withdrawalParams != null) {
        return ParsedInput(InputProtocol.lnurlWithdraw, lower);
      }
      throw Exception("not implemented");
    } else if (lower.contains(lnurlRfc17Prefix) ||
        lower.startsWith('keyauth://')) {
      // Check if input is a valid url
      if (Uri.tryParse(lower)?.hasAbsolutePath ?? false) {
        // Replace prefix with https for clearnet URL's, http for onion URLs
        var prefix =
            RegExp(r'\.onion($|\W)').hasMatch(lower) ? 'http' : 'https';
        final invoice = lower.replaceFirst(RegExp("(lnurl)(c|w|p)"), prefix);
        InputProtocol? inputProtocol = lower.startsWith("lnurlp://")
            ? InputProtocol.lnurlPay
            : lower.startsWith("lnurlw://")
                ? InputProtocol.lnurlWithdraw
                : null;
        if (inputProtocol != null) {
          return ParsedInput(InputProtocol.lnurlPay, invoice);
        }
        throw Exception("not implemented");
      }
    } else if (lower.startsWith('https://')) {
      throw Exception("not implemented");
    }

    // bolt 11 lightning
    String? bolt11 = _extractBolt11FromBip21(lower);
    if (bolt11 != null) {
      final invoice = await _lnToolkit.parseInvoice(invoice: bolt11);
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    }
    try {
      final invoice = await _lnToolkit.parseInvoice(invoice: lower);
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    } catch(e) {}

    throw Exception("not implemented");
  }
}

String? _extractBolt11FromBip21(String bip21) {
  String lowerBip21 = bip21.toLowerCase();
  if (lowerBip21.startsWith("bitcoin:")) {
    try {
      Uri uri = Uri.parse(lowerBip21);
      String? bolt11 = uri.queryParameters["lightning"];
      if (bolt11 != null && bolt11.isNotEmpty) {
        return bolt11;
      }
    } on FormatException {
      // do nothing.
    }
  }
  return null;
}

enum InputProtocol {paymentRequest, lnurlPay, lnurlWithdraw}

class ParsedInput {
  final InputProtocol protocol;
  final dynamic decoded;

  ParsedInput(this.protocol, this.decoded);
}
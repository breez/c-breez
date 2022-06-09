import '../generated/bridge_generated.dart';
import 'native_toolkit.dart';


class InputParser {
  final LightningToolkit _lnToolkit = getNativeToolkit();  

  Future<ParsedInput> parse(String s) async {

    // lightning link
    String lower = s.toLowerCase();
    if (lower.startsWith("lightning:")) {
      final invoice = await _lnToolkit.parseInvoice(invoice: s.substring(10));
      return ParsedInput(InputProtocol.paymentRequest, invoice);
    }

    // lnurl
    if (lower.startsWith("lnurl")) {
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
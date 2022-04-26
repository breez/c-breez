import 'package:fixnum/fixnum.dart';

import '../models/currency.dart';

BTCAddressInfo parseBTCAddress(String scannedString) {
  String? address;
  Int64? satAmount;
  Uri? uri = Uri.tryParse(scannedString);
  if (uri != null) {
    address = uri.path;
    if (uri.queryParameters["amount"] != null) {
      double? btcAmount = double.tryParse(uri.queryParameters["amount"] ?? "");
      satAmount = btcAmount != null ? BitcoinCurrency.BTC.toSats(btcAmount) : null;
    }
  }
  return BTCAddressInfo(address, satAmount: satAmount);
}

class BTCAddressInfo {
  final String? address;
  final Int64? satAmount;

  BTCAddressInfo(this.address, {this.satAmount});
}

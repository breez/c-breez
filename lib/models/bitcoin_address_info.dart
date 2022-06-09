import 'package:c_breez/models/currency.dart';
import 'package:fixnum/fixnum.dart';

class BitcoinAddressInfo {
  final String? address;
  final Int64? satAmount;

  const BitcoinAddressInfo(
    this.address,
    this.satAmount,
  );

  factory BitcoinAddressInfo.fromScannedString(String? scannedString) {
    String? address;
    Int64? satAmount;
    if (scannedString != null) {
      final uri = Uri.tryParse(scannedString);
      if (uri != null) {
        address = uri.path;
        final amount = uri.queryParameters["amount"];
        if (amount != null) {
          final btcAmount = double.tryParse(amount);
          if (btcAmount != null) {
            satAmount = BitcoinCurrency.BTC.toSats(btcAmount);
          }
        }
      }
    }
    return BitcoinAddressInfo(address, satAmount);
  }
}

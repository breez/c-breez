import 'package:c_breez/models/currency.dart';

class BitcoinAddressInfo {
  final String? address;
  final int? satAmount;

  const BitcoinAddressInfo(
    this.address,
    this.satAmount,
  );

  factory BitcoinAddressInfo.fromScannedString(String? scannedString) {
    String? address;
    int? satAmount;
    if (scannedString != null) {
      final uri = Uri.tryParse(scannedString);
      if (uri != null) {
        address = uri.path;
        final amountSat = uri.queryParameters["amount"];
        if (amountSat != null) {
          final btcAmount = double.tryParse(amountSat);
          if (btcAmount != null) {
            satAmount = BitcoinCurrency.BTC.toSats(btcAmount);
          }
        }
      }
    }
    return BitcoinAddressInfo(address, satAmount);
  }
}

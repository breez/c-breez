import 'package:hex/hex.dart';

class Withdrawal {
  final String txid;
  final String tx;

  const Withdrawal(this.txid, this.tx);

  List<int> get txBytes => HEX.decode(tx);
}

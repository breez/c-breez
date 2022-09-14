import 'package:breez_sdk/sdk.dart';
import 'package:breez_sdk/src/storage/dao/db.dart';

class SwapLiveData {
  final Swap swap;
  final List<OnchainTransaction> transactions;

  SwapLiveData(this.swap, this.transactions);

  int get confirmedAmount {
    int balance = 0;
    transactions.where((tx) => tx.confirmed).forEach((tx) {
      for (var i in tx.inputs) {
        if (i.prevOut.scriptpubkeyAddress == swap.bitcoinAddress) {
          balance -= i.prevOut.value;
        }
      }
      for (var o in tx.outputs) {
        if (o.scriptpubkeyAddress == swap.bitcoinAddress) {
          balance += o.value;
        }
      }
    });
    return balance;
  }

  List<OnchainTransaction> get spendingTxs =>
      transactions.where((tx) => tx.inputs.any((i) => i.prevOut.scriptpubkeyAddress == swap.bitcoinAddress)).toList();

  bool get redeemable => confirmedAmount > 0 && swap.paidSats == 0 && spendingTxs.isEmpty;
}
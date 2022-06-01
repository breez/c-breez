import 'package:c_breez/bloc/account/swap_funds.dart';
import 'package:flutter/cupertino.dart';

class SwapRefundDialog extends StatelessWidget {
  final List<RefundableAddress> address;

  const SwapRefundDialog(
    this.address, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("TODO SwapRefundDialog: $address");
  }
}

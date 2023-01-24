import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_item_avatar.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogTitle extends StatelessWidget {
  final Payment paymentInfo;

  const PaymentDetailsDialogTitle({
    super.key,
    required this.paymentInfo,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        Container(
          decoration: ShapeDecoration(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.0),
              ),
            ),
            color: themeData.isLightTheme ? themeData.primaryColorDark : themeData.canvasColor,
          ),
          height: 64.0,
          width: mediaQuery.size.width,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Center(
            child: PaymentItemAvatar(
              paymentInfo,
              radius: 32.0,
            ),
          ),
        ),
      ],
    );
  }
}

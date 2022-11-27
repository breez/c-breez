import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/routes/home/widgets/payments_list/flip_transition.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_details_dialog.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_item_amount.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_item_avatar.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_item_subtitle.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_item_title.dart';
import 'package:c_breez/routes/home/widgets/payments_list/success_avatar.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class PaymentItem extends StatelessWidget {
  final Payment _paymentInfo;
  final bool _firstItem;
  final bool _hideBalance;
  final GlobalKey firstPaymentItemKey;

  const PaymentItem(
    this._paymentInfo,
    this._firstItem,
    this._hideBalance,
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Theme.of(context).customData.paymentListBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Container(
                  height: 72.0,
                  decoration: _createdWithin(const Duration(seconds: 10))
                      ? BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 5.0,
                            ),
                          ],
                        )
                      : null,
                  child: _createdWithin(const Duration(seconds: 10))
                      ? PaymentItemAvatar(_paymentInfo, radius: 16)
                      : FlipTransition(
                          PaymentItemAvatar(
                            _paymentInfo,
                            radius: 16,
                          ),
                          const SuccessAvatar(radius: 16),
                          radius: 16,
                        ),
                ),
                key: _firstItem ? firstPaymentItemKey : null,
                title: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: PaymentItemTitle(_paymentInfo),
                ),
                subtitle: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: PaymentItemSubtitle(_paymentInfo),
                ),
                trailing: PaymentItemAmount(_paymentInfo, _hideBalance),
                onTap: () => _showDetail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _createdWithin(Duration duration) {
    final diff = DateTime.fromMillisecondsSinceEpoch(
      _paymentInfo.paymentTime * 1000,
    ).difference(
      DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return diff < -duration;
  }

  void _showDetail(BuildContext context) {
    showPaymentDetailsDialog(context, _paymentInfo);
  }
}

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/home/widgets/payments_list/dialog/shareable_payment_row.dart';
import 'package:flutter/material.dart';

class PaymentDetailsDialogSuccessAction extends StatelessWidget {
  final Payment paymentInfo;

  const PaymentDetailsDialogSuccessAction({
    super.key,
    required this.paymentInfo,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final details = paymentInfo.details.data;
    if (details is LnPaymentDetails && details.lnurlSuccessAction != null) {
      final successAction = details.lnurlSuccessAction;
      String message = '';
      String? url;
      if (successAction is SuccessActionProcessed_Message) {
        message = successAction.data.message;
      } else if (successAction is SuccessActionProcessed_Url) {
        message = successAction.data.description;
        url = successAction.data.url;
      } else if (successAction is SuccessActionProcessed_Aes) {
        message = "${successAction.data.description} ${successAction.data.plaintext}";
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShareablePaymentRow(
            title: texts.payment_details_dialog_action_for_payment_description,
            sharedValue: message,
          ),
          if (url != null) ...[
            ShareablePaymentRow(
              title: texts.payment_details_dialog_action_for_payment_url,
              sharedValue: url,
            ),
          ]
        ],
      );
    } else {
      return Container();
    }
  }
}

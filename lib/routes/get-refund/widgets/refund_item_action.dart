import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/get-refund/refund_confirmation_page.dart';
import 'package:c_breez/routes/spontaneous_payment/widgets/collapsible_list_item.dart';
import 'package:c_breez/routes/withdraw/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class RefundItemAction extends StatefulWidget {
  final SwapInfo swapInfo;

  const RefundItemAction(
    this.swapInfo, {
    super.key,
  });

  @override
  State<RefundItemAction> createState() => _RefundItemActionState();
}

class _RefundItemActionState extends State<RefundItemAction> {
  final _addressController = TextEditingController();
  final _validatorHolder = ValidatorHolder();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final ids = widget.swapInfo.confirmedTxIds;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.swapInfo.confirmedTxIds[0].isNotEmpty) ...[
            CollapsibleListItem(
              title: texts.send_on_chain_original_transaction,
              sharedValue: ids[ids.length - 1],
              userStyle: const TextStyle(color: Colors.white),
            ),
          ],
          BitcoinAddressTextFormField(
              context: context, controller: _addressController, validatorHolder: _validatorHolder),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 36.0,
              width: 145.0,
              child: SubmitButton(texts.get_refund_action_continue, () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).push(
                    FadeInRoute(
                      builder: (_) => RefundConfirmationPage(
                        amountSat: widget.swapInfo.confirmedSats,
                        toAddress: _addressController.text,
                        swapAddress: widget.swapInfo.bitcoinAddress,
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

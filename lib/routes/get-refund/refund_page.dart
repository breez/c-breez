import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/get-refund/refund_confirmation_page.dart';
import 'package:c_breez/routes/spontaneous_payment/widgets/collapsible_list_item.dart';
import 'package:c_breez/routes/withdraw/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/available_btc.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;

class RefundPage extends StatefulWidget {
  final SwapInfo swapInfo;
  const RefundPage(
    this.swapInfo, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return RefundPageState();
  }
}

class RefundPageState extends State<RefundPage> {
  final _addressController = TextEditingController();
  final _validatorHolder = ValidatorHolder();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final ids = widget.swapInfo.confirmedTxIds;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const back_button.BackButton(),
        title: Text(texts.get_refund_title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    BitcoinAddressTextFormField(
                      context: context,
                      controller: _addressController,
                      validatorHolder: _validatorHolder,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: AvailableBTC(widget.swapInfo.confirmedSats),
                    ),
                    CollapsibleListItem(
                      title: texts.send_on_chain_original_transaction,
                      userStyle: theme.FieldTextStyle.textStyle,
                      sharedValue: ids[ids.length - 1],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        text: texts.get_refund_action_continue,
        onPressed: () {
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
        },
      ),
    );
  }
}

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/withdraw_funds_address_next_button.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/withdraw_funds_available_btc.dart';
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';

class WithdrawFundsAddressPage extends StatefulWidget {
  final WithdrawKind withdrawKind;
  const WithdrawFundsAddressPage({
    Key? key,
    required this.withdrawKind,
  }) : super(key: key);

  @override
  State<WithdrawFundsAddressPage> createState() =>
      _WithdrawFundsAddressPageState();
}

class _WithdrawFundsAddressPageState extends State<WithdrawFundsAddressPage> {
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: Text(
          widget.withdrawKind == WithdrawKind.withdraw_funds
              ? texts.reverse_swap_title
              : texts.unexpected_funds_title,
        ),
      ),
      body: Column(
        children: [
          WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Text(
              texts.unexpected_funds_message,
              style: themeData.textTheme.headline6,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Form(
              key: _formKey,
              child: BitcoinAddressTextFormField(
                context: context,
                controller: _addressController,
                validatorHolder: ValidatorHolder(),
              ),
            ),
          ),
          const WithdrawFundsAvailableBtc(),
          Expanded(child: Container()),
          WithdrawFundsAddressNextButton(
            addressController: _addressController,
            validator: () => _formKey.currentState?.validate() ?? false,
          ),
        ],
      ),
    );
  }
}

enum WithdrawKind {
  withdraw_funds,
  unexpected_funds,
}

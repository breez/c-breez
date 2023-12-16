import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/withdraw/model/withdraw_funds_model.dart';
import 'package:c_breez/routes/withdraw/redeem_onchain_funds/confirmation_page/redeem_onchain_funds_confirmation.dart';
import 'package:c_breez/routes/withdraw/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/routes/withdraw/widgets/withdraw_funds_amount_text_form_field.dart';
import 'package:c_breez/routes/withdraw/widgets/withdraw_funds_available_btc.dart';
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/amount_form_field/sat_amount_form_field_formatter.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("RedeemFundsPage");

class RedeemFundsPage extends StatefulWidget {
  final int walletBalance;

  const RedeemFundsPage({
    required this.walletBalance,
    super.key,
  });

  @override
  State<RedeemFundsPage> createState() => _RedeemFundsPageState();
}

class _RedeemFundsPageState extends State<RedeemFundsPage> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validatorHolder = ValidatorHolder();
  bool _withdrawMaxValue = true;

  @override
  void initState() {
    super.initState();
    if (_withdrawMaxValue) {
      _setAmount(widget.walletBalance);
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        title: Text(texts.unexpected_funds_title),
      ),
      body: Column(
        children: [
          WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Text(
              texts.unexpected_funds_message,
              style: themeData.textTheme.titleLarge,
            ),
          ),
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
                  BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, state) {
                      return WithdrawFundsAmountTextFormField(
                        context: context,
                        bitcoinCurrency: state.bitcoinCurrency,
                        controller: _amountController,
                        withdrawMaxValue: _withdrawMaxValue,
                        policy: WithdrawFundsPolicy(
                          WithdrawKind.unexpected_funds,
                          widget.walletBalance,
                          widget.walletBalance,
                        ),
                        balance: widget.walletBalance,
                      );
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      texts.withdraw_funds_use_all_funds,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                    ),
                    trailing: Switch(
                      value: _withdrawMaxValue,
                      activeColor: Colors.white,
                      onChanged: (bool value) async {
                        setState(() {
                          _withdrawMaxValue = value;
                          if (_withdrawMaxValue) {
                            _setAmount(widget.walletBalance);
                          } else {
                            _amountController.text = "";
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const WithdrawFundsAvailableBtc(),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SubmitButton(
              texts.withdraw_funds_action_next,
              () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).push(
                    FadeInRoute(
                      builder: (_) => RedeemOnchainConfirmationPage(
                        toAddress: _addressController.text,
                        amountSat: _getAmount(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getAmount() {
    final bitcoinCurrency = context.read<CurrencyBloc>().state.bitcoinCurrency;

    int amount = 0;
    try {
      amount = bitcoinCurrency.parse(_amountController.text);
    } catch (e) {
      _log.warning("Failed to parse the input amount", e);
    }
    return amount;
  }

  void _setAmount(int amountSats) {
    final bitcoinCurrency = context.read<CurrencyBloc>().state.bitcoinCurrency;

    setState(() {
      _amountController.text = bitcoinCurrency
          .format(amountSats, includeDisplayName: false, userInput: true)
          .formatBySatAmountFormFieldFormatter();
    });
  }
}

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/withdraw_amount_text_form_field.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/withdraw_funds_address_next_button.dart';
import 'package:c_breez/routes/withdraw_funds/widgets/withdraw_funds_available_btc.dart';
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/amount_form_field/sat_amount_form_field_formatter.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/warning_box.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("WithdrawFundsAddressPage");

class WithdrawFundsAddressPage extends StatefulWidget {
  final WithdrawFundsPolicy policy;

  const WithdrawFundsAddressPage({
    Key? key,
    required this.policy,
  }) : super(key: key);

  @override
  State<WithdrawFundsAddressPage> createState() => _WithdrawFundsAddressPageState();
}

class _WithdrawFundsAddressPageState extends State<WithdrawFundsAddressPage> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validatorHolder = ValidatorHolder();
  bool _withdrawMaxValue = false;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: Text(
          widget.policy.withdrawKind == WithdrawKind.withdraw_funds
              ? texts.reverse_swap_title
              : texts.unexpected_funds_title,
        ),
      ),
      body: Column(
        children: [
          if (widget.policy.withdrawKind == WithdrawKind.unexpected_funds)
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
                      return WithdrawAmountTextFormField(
                        context: context,
                        bitcoinCurrency: state.bitcoinCurrency,
                        controller: _amountController,
                        withdrawKind: widget.policy.withdrawKind,
                        withdrawMaxValue: _withdrawMaxValue,
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
                    trailing: BlocBuilder<CurrencyBloc, CurrencyState>(
                      builder: (context, currency) {
                        return Switch(
                          value: _withdrawMaxValue,
                          activeColor: Colors.white,
                          onChanged: (bool value) async {
                            setState(() {
                              _withdrawMaxValue = value;
                              if (_withdrawMaxValue) {
                                _amountController.text = currency.bitcoinCurrency
                                    .format(
                                      widget.policy.maxValue,
                                      includeDisplayName: false,
                                      userInput: true,
                                    )
                                    .formatBySatAmountFormFieldFormatter();
                              } else {
                                _amountController.text = "";
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const WithdrawFundsAvailableBtc(),
          Expanded(child: Container()),
          BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (context, currency) {
              return WithdrawFundsAddressNextButton(
                addressController: _addressController,
                validator: () => _formKey.currentState?.validate() ?? false,
                amount: () {
                  int amount = 0;
                  try {
                    amount = currency.bitcoinCurrency.parse(_amountController.text);
                  } catch (e) {
                    _log.w("Failed to parse the input amount", ex: e);
                  }
                  return amount;
                },
              );
            },
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

class WithdrawFundsPolicy {
  final WithdrawKind withdrawKind;
  final int minValue;
  final int maxValue;

  const WithdrawFundsPolicy(
    this.withdrawKind,
    this.minValue,
    this.maxValue,
  );
}

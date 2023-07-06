import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment_dialog.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/collapsible_list_item.dart';

class SpontaneousPaymentPage extends StatefulWidget {
  final String? nodeID;
  final GlobalKey firstPaymentItemKey;

  const SpontaneousPaymentPage(
    this.nodeID,
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SpontaneousPaymentPageState();
  }
}

class SpontaneousPaymentPageState extends State<SpontaneousPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final FocusNode _amountFocusNode = FocusNode();
  KeyboardDoneAction? _doneAction;
  ModalRoute? _currentRoute;

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(focusNodes: <FocusNode>[_amountFocusNode]);
    Future.delayed(
      const Duration(milliseconds: 200),
      () => FocusScope.of(context).requestFocus(_amountFocusNode),
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  void dispose() {
    _doneAction!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    AccountBloc accountBloc = context.read<AccountBloc>();
    CurrencyBloc currencyBloc = context.read<CurrencyBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        title: Text(texts.spontaneous_payment_title),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, currencyState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, acc) {
            AccountBloc accBloc = context.read<AccountBloc>();
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
                child: ListView(
                  children: <Widget>[
                    _buildNodeIdDescription(),
                    TextFormField(
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      maxLines: null,
                      maxLength: 90,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      decoration: InputDecoration(
                        labelText: texts.spontaneous_payment_tip_message,
                      ),
                      style: theme.FieldTextStyle.textStyle,
                    ),
                    AmountFormField(
                        context: context,
                        bitcoinCurrency: currencyState.bitcoinCurrency,
                        texts: texts,
                        fiatConversion: currencyState.fiatEnabled
                            ? FiatConversion(currencyState.fiatCurrency!, currencyState.fiatExchangeRate!)
                            : null,
                        focusNode: _amountFocusNode,
                        controller: _amountController,
                        validatorFn: PaymentValidator(
                          validatePayment: accBloc.validatePayment,
                          currency: currencyState.bitcoinCurrency,
                          texts: context.texts(),
                        ).validateOutgoing,
                        style: theme.FieldTextStyle.textStyle),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      padding: const EdgeInsets.only(top: 16.0),
                      child: _buildPayableBTC(currencyState, acc),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: SingleButtonBottomBar(
          stickToBottom: true,
          text: texts.spontaneous_payment_action_pay,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _sendPayment(accountBloc, currencyBloc);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPayableBTC(CurrencyState currencyState, AccountState acc) {
    final texts = context.texts();
    return GestureDetector(
      child: AutoSizeText(
        texts.spontaneous_payment_max_amount(
          currencyState.bitcoinCurrency.format(acc.maxAllowedToPay),
        ),
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = currencyState.bitcoinCurrency.format(
        acc.maxAllowedToPay,
        includeDisplayName: false,
        userInput: true,
      ),
    );
  }

  Widget _buildNodeIdDescription() {
    final texts = context.texts();
    return CollapsibleListItem(
      title: texts.spontaneous_payment_node_id,
      sharedValue: widget.nodeID,
      userStyle: const TextStyle(color: Colors.white),
    );
  }

  Future _sendPayment(AccountBloc accBloc, CurrencyBloc currencyBloc) async {
    final texts = context.texts();

    String tipMessage = _descriptionController.text;
    var bitcoinCurrency = currencyBloc.state.bitcoinCurrency;
    var amount = bitcoinCurrency.parse(_amountController.text);
    _amountFocusNode.unfocus();
    await promptAreYouSure(
      context,
      texts.spontaneous_payment_send_payment_title,
      Text(
        texts.spontaneous_payment_send_payment_message(
          bitcoinCurrency.format(amount),
          widget.nodeID!,
        ),
      ),
      okText: texts.spontaneous_payment_action_pay,
      cancelText: texts.spontaneous_payment_action_cancel,
    ).then(
      (ok) async {
        if (ok == true) {
          Future sendFuture = Future.value(null);
          showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (_) => ProcessingPaymentDialog(
              firstPaymentItemKey: widget.firstPaymentItemKey,
              popOnCompletion: true,
              paymentFunc: () {
                var sendPayment = Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    sendFuture = accBloc.sendSpontaneousPayment(
                      widget.nodeID!,
                      tipMessage,
                      amount,
                    );
                    return sendFuture;
                  },
                );

                return sendPayment;
              },
            ),
          );
          if (!mounted) return;
          Navigator.of(context).removeRoute(_currentRoute!);
          await sendFuture;
        }
      },
    );
  }
}

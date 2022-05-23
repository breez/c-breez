import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as backBtn;
import 'package:c_breez/widgets/collapsible_list_item.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:c_breez/widgets/processing_payment_dialog.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    Future.delayed(const Duration(milliseconds: 200),
        () => FocusScope.of(context).requestFocus(_amountFocusNode));
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
    final texts = AppLocalizations.of(context)!;
    AccountBloc accountBloc = context.read<AccountBloc>();
    CurrencyBloc currencyBloc = context.read<CurrencyBloc>();

    return Scaffold(
      appBar: AppBar(
        leading: const backBtn.BackButton(),
        title: const Text("Send Payment"),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, currencyState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, acc) {
            AccountBloc accBloc = context.read<AccountBloc>();
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 40.0, top: 24.0),
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
                      decoration: const InputDecoration(
                        labelText: "Tip Message (optional)",
                      ),
                      style: theme.FieldTextStyle.textStyle,
                    ),
                    AmountFormField(
                        context: context,
                        bitcoinCurrency: currencyState.bitcoinCurrency,
                        texts: texts,
                        fiatConversion: currencyState.fiatEnabled
                            ? FiatConversion(currencyState.fiatCurrency!,
                                currencyState.fiatExchangeRate!)
                            : null,
                        focusNode: _amountFocusNode,
                        controller: _amountController,
                        validatorFn: PaymentValidator(accBloc.validatePayment,
                                currencyState.bitcoinCurrency)
                            .validateOutgoing,
                        style: theme.FieldTextStyle.textStyle),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      padding: const EdgeInsets.only(top: 16.0),
                      child: _buildPayableBTC(currencyState, acc),
                    ),
                    BlocBuilder<AccountBloc, AccountState>(
                        builder: (BuildContext context, AccountState acc) {
                      String? message;
                      if (acc.status == AccountStatus.CONNECTING) {
                        message =
                            'You will be able to receive payments after Breez is finished opening a secure channel with our server. This usually takes ~10 minutes to be completed. Please try again in a couple of minutes.';
                      }

                      if (message != null) {
                        final themeData = Theme.of(context);
                        return Container(
                            padding: const EdgeInsets.only(
                              top: 32.0,
                              left: 16.0,
                              right: 16.0,
                            ),
                            child: Column(children: <Widget>[
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: themeData.textTheme.headline6!.copyWith(
                                  color: themeData.colorScheme.error,
                                ),
                              ),
                            ]));
                      } else {
                        return const SizedBox();
                      }
                    })
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
          text: "PAY",
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
    return GestureDetector(
      child: AutoSizeText(
        "Pay up to: ${currencyState.bitcoinCurrency.format(acc.maxAllowedToPay)}",
        style: theme.textStyle,
        maxLines: 1,
        minFontSize: MinFontSize(context).minFontSize,
      ),
      onTap: () => _amountController.text = currencyState.bitcoinCurrency
          .format(acc.maxAllowedToPay,
              includeDisplayName: false, userInput: true),
    );
  }

  Widget _buildNodeIdDescription() {
    return CollapsibleListItem(
        title: "Node ID",
        sharedValue: widget.nodeID,
        userStyle: const TextStyle(color: Colors.white));
  }

  Future _sendPayment(AccountBloc accBloc, CurrencyBloc currencyBloc) async {
    String tipMessage = _descriptionController.text;
    var bitcoinCurrency = currencyBloc.state.bitcoinCurrency;
    var amount = bitcoinCurrency.parse(_amountController.text);
    _amountFocusNode.unfocus();
    var ok = await promptAreYouSure(
        context,
        "Send Payment",
        Text(
            "Are you sure you want to ${bitcoinCurrency.format(amount)} to this node?\n\n${widget.nodeID}"),
        okText: "PAY",
        cancelText: "CANCEL");
    if (ok == true) {
      try {
        Future sendFuture = Future.value(null);
        showDialog(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (_) => ProcessingPaymentDialog(
                  () {
                    var sendPayment =
                        Future.delayed(const Duration(seconds: 1), () {
                      // accBloc.userActionsSink.add(sendAction);
                      sendFuture = accBloc.sendSpontaneousPayment(
                          widget.nodeID!, tipMessage, amount);
                      return sendFuture;
                    });

                    return sendPayment;
                  },
                  widget.firstPaymentItemKey,
                  (_) {},
                  220,
                  popOnCompletion: true,
                ));
        Navigator.of(context).removeRoute(_currentRoute!);
        await sendFuture;
      } catch (err) {
        promptError(
            context,
            "Payment Error",
            Text(
              err.toString(),
              style: Theme.of(context).dialogTheme.contentTextStyle,
            ));
      }
    }
  }
}

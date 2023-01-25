import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentRequestInfoDialog extends StatefulWidget {
  final Invoice invoice;
  final Function() _onCancel;
  final Function() _onWaitingConfirmation;
  final Function(String bot11, int amount) _onPaymentApproved;
  final Function(Map<String, dynamic> map) _setAmountToPay;
  final double minHeight;

  const PaymentRequestInfoDialog(
    this.invoice,
    this._onCancel,
    this._onWaitingConfirmation,
    this._onPaymentApproved,
    this._setAmountToPay,
    this.minHeight, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestInfoDialogState();
  }
}

class PaymentRequestInfoDialogState extends State<PaymentRequestInfoDialog> {
  final _dialogKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _invoiceAmountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _amountToPayMap = <String, dynamic>{};

  KeyboardDoneAction? _doneAction;
  bool _showFiatCurrency = false;

  @override
  void initState() {
    super.initState();
    _invoiceAmountController.addListener(() {
      setState(() {});
    });
    _doneAction = KeyboardDoneAction(focusNodes: [_amountFocusNode]);
  }

  @override
  void dispose() {
    _doneAction?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> paymentRequestDialog = [];
    _addIfNotNull(paymentRequestDialog, _buildPaymentRequestTitle());
    _addIfNotNull(paymentRequestDialog, _buildPaymentRequestContent());
    return Dialog(
      child: Container(
        constraints: BoxConstraints(minHeight: widget.minHeight),
        key: _dialogKey,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: paymentRequestDialog,
        ),
      ),
    );
  }

  Widget? _buildPaymentRequestTitle() {
    return widget.invoice.payeeImageURL.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 48, bottom: 8),
            child: BreezAvatar(
              widget.invoice.payeeImageURL,
              radius: 32.0,
            ),
          );
  }

  Widget _buildPaymentRequestContent() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (c, currencyState) {
      return BlocBuilder<AccountBloc, AccountState>(
        builder: (context, account) {
          List<Widget> children = [];
          _addIfNotNull(children, _buildPayeeNameWidget(context));
          _addIfNotNull(children, _buildRequestPayTextWidget(context));
          _addIfNotNull(
              children, _buildAmountWidget(context, account, currencyState));
          _addIfNotNull(children, _buildDescriptionWidget(context));
          _addIfNotNull(children, _buildErrorMessage(context, currencyState));
          _addIfNotNull(
              children, _buildActions(context, currencyState, account));

          return Container(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          );
        },
      );
    });
  }

  void _addIfNotNull(List<Widget> widgets, Widget? w) {
    if (w != null) {
      widgets.add(w);
    }
  }

  Widget? _buildPayeeNameWidget(BuildContext context) {
    return widget.invoice.payeeName.isEmpty
        ? null
        : Text(
            widget.invoice.payeeName,
            style: Theme.of(context)
                .primaryTextTheme
                .headlineMedium!
                .copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          );
  }

  Widget _buildRequestPayTextWidget(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final payeeName = widget.invoice.payeeName;

    return Text(
      payeeName.isEmpty
          ? texts.payment_request_dialog_requested
          : texts.payment_request_dialog_requesting,
      style: themeData.primaryTextTheme.displaySmall!.copyWith(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAmountWidget(
      BuildContext context, AccountState account, CurrencyState currencyState) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    if (widget.invoice.amountMsat == 0) {
      return Theme(
        data: themeData.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: theme.greyBorderSide,
            ),
          ),
          hintColor: themeData.dialogTheme.contentTextStyle!.color,
          colorScheme: ColorScheme.dark(
            primary: themeData.textTheme.labelLarge!.color!,
            error: themeData.isLightTheme
                ? Colors.red
                : themeData.colorScheme.error,
          ),
          primaryColor: themeData.textTheme.labelLarge!.color!,
        ),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              height: 80.0,
              child: AmountFormField(
                context: context,
                texts: texts,
                bitcoinCurrency: BitcoinCurrency.fromTickerSymbol(
                    currencyState.bitcoinTicker),
                iconColor: themeData.primaryIconTheme.color,
                focusNode: _amountFocusNode,
                controller: _invoiceAmountController,
                validatorFn: PaymentValidator(
                  context.read<AccountBloc>().validatePayment,
                  currencyState.bitcoinCurrency,
                  texts: context.texts(),
                ).validateOutgoing,
                style: themeData.dialogTheme.contentTextStyle!
                    .copyWith(height: 1.0),
              ),
            ),
          ),
        ),
      );
    }

    FiatConversion? fiatConversion;
    if (currencyState.fiatEnabled) {
      fiatConversion = FiatConversion(
          currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) {
        setState(() {
          _showFiatCurrency = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _showFiatCurrency = false;
        });
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
        ),
        child: Text(
          _showFiatCurrency && fiatConversion != null
              ? fiatConversion.format(widget.invoice.amountMsat ~/ 1000)
              : BitcoinCurrency.fromTickerSymbol(currencyState.bitcoinTicker)
                  .format(widget.invoice.amountMsat ~/ 1000),
          style: themeData.primaryTextTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget? _buildDescriptionWidget(BuildContext context) {
    final themeData = Theme.of(context);
    final description = widget.invoice.description;

    return description.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
                minWidth: double.infinity,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: AutoSizeText(
                    description,
                    style: themeData.primaryTextTheme.displaySmall!
                        .copyWith(fontSize: 16),
                    textAlign:
                        description.length > 40 && !description.contains("\n")
                            ? TextAlign.start
                            : TextAlign.center,
                  ),
                ),
              ),
            ),
          );
  }

  Widget? _buildErrorMessage(
      BuildContext context, CurrencyState currencyState) {
    final validationError = PaymentValidator(
      context.read<AccountBloc>().validatePayment,
      currencyState.bitcoinCurrency,
      texts: context.texts(),
    ).validateOutgoing(
      amountToPay(currencyState),
    );
    if (widget.invoice.amountMsat == 0 || validationError == null || validationError.isEmpty) {
      return null;
    }

    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: AutoSizeText(
        validationError,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: themeData.primaryTextTheme.displaySmall!.copyWith(
          fontSize: 16,
          color:
              themeData.isLightTheme ? Colors.red : themeData.colorScheme.error,
        ),
      ),
    );
  }

  Widget _buildActions(
      BuildContext context, CurrencyState currency, AccountState accState) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => widget._onCancel(),
        child: Text(
          texts.payment_request_dialog_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      )
    ];

    int toPay = amountToPay(currency);
    if (toPay > 0 && accState.maxAllowedToPay >= toPay) {
      actions.add(SimpleDialogOption(
        onPressed: (() async {
          if (widget.invoice.amountMsat > 0 || _formKey.currentState!.validate()) {
            if (widget.invoice.amountMsat == 0) {
              _amountToPayMap["_amountToPay"] = toPay;
              _amountToPayMap["_amountToPayStr"] =
                  BitcoinCurrency.fromTickerSymbol(currency.bitcoinTicker)
                      .format(amountToPay(currency));
              widget._setAmountToPay(_amountToPayMap);
              widget._onWaitingConfirmation();
            } else {
              widget._onPaymentApproved(
                widget.invoice.bolt11,
                amountToPay(currency),
              );
            }
          }
        }),
        child: Text(
          texts.payment_request_dialog_action_approve,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      ));
    }
    return Theme(
      data: themeData.copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        ),
      ),
    );
  }

  int amountToPay(CurrencyState acc) {
    int amount = widget.invoice.amountMsat ~/ 1000;
    if (amount == 0) {
      try {
        amount = BitcoinCurrency.fromTickerSymbol(acc.bitcoinTicker)
            .parse(_invoiceAmountController.text);
      } catch (_) {}
    }
    return amount;
  }
}

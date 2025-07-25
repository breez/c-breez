import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentRequestInfoDialog extends StatefulWidget {
  final Invoice invoice;
  final Function() _onCancel;
  final Function() _onWaitingConfirmation;
  final Function(String bot11, int amountSat) _onPaymentApproved;
  final Function(Map<String, dynamic> map) _setAmountToPay;
  final double minHeight;

  const PaymentRequestInfoDialog(
    this.invoice,
    this._onCancel,
    this._onWaitingConfirmation,
    this._onPaymentApproved,
    this._setAmountToPay,
    this.minHeight, {
    super.key,
  });

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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            child: BreezAvatar(widget.invoice.payeeImageURL, radius: 32.0),
          );
  }

  Widget _buildPaymentRequestContent() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (c, currencyState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, account) {
            List<Widget> children = [];
            _addIfNotNull(children, _buildPayeeNameWidget());
            _addIfNotNull(children, _buildRequestPayTextWidget());
            _addIfNotNull(children, _buildAmountWidget(account, currencyState));
            _addIfNotNull(children, _buildDescriptionWidget());
            _addIfNotNull(children, _buildErrorMessage(currencyState));
            _addIfNotNull(children, _buildActions(currencyState, account));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: children),
            );
          },
        );
      },
    );
  }

  void _addIfNotNull(List<Widget> widgets, Widget? w) {
    if (w != null) {
      widgets.add(w);
    }
  }

  Widget? _buildPayeeNameWidget() {
    return widget.invoice.payeeName.isEmpty
        ? null
        : Text(
            widget.invoice.payeeName,
            style: Theme.of(context).primaryTextTheme.headlineMedium!.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          );
  }

  Widget _buildRequestPayTextWidget() {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final payeeName = widget.invoice.payeeName;

    return Text(
      payeeName.isEmpty ? texts.payment_request_dialog_requested : texts.payment_request_dialog_requesting,
      style: themeData.primaryTextTheme.displaySmall!.copyWith(fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAmountWidget(AccountState account, CurrencyState currencyState) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    if (widget.invoice.amountMsat == 0) {
      return Theme(
        data: themeData.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(borderSide: theme.greyBorderSide),
          ),
          hintColor: themeData.dialogTheme.contentTextStyle!.color,
          colorScheme: ColorScheme.dark(
            primary: themeData.textTheme.labelLarge!.color!,
            error: themeData.isLightTheme ? Colors.red : themeData.colorScheme.error,
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
                bitcoinCurrency: BitcoinCurrency.fromTickerSymbol(currencyState.bitcoinTicker),
                iconColor: themeData.primaryIconTheme.color,
                focusNode: _amountFocusNode,
                controller: _invoiceAmountController,
                validatorFn: PaymentValidator(
                  validatePayment: context.read<AccountBloc>().validatePayment,
                  channelCreationPossible: context.read<LSPBloc>().state?.isChannelOpeningAvailable ?? false,
                  currency: currencyState.bitcoinCurrency,
                  texts: context.texts(),
                ).validateOutgoing,
                style: themeData.dialogTheme.contentTextStyle!.copyWith(height: 1.0),
              ),
            ),
          ),
        ),
      );
    }

    FiatConversion? fiatConversion;
    if (currencyState.fiatEnabled) {
      fiatConversion = FiatConversion(currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);
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
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: Text(
          _showFiatCurrency && fiatConversion != null
              ? fiatConversion.format(widget.invoice.amountMsat ~/ 1000)
              : BitcoinCurrency.fromTickerSymbol(
                  currencyState.bitcoinTicker,
                ).format(widget.invoice.amountMsat ~/ 1000),
          style: themeData.primaryTextTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget? _buildDescriptionWidget() {
    final themeData = Theme.of(context);
    final description = widget.invoice.extractDescription();

    return description.isEmpty
        ? null
        : Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200, minWidth: double.infinity),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: AutoSizeText(
                    description,
                    style: themeData.primaryTextTheme.displaySmall!.copyWith(fontSize: 16),
                    textAlign: description.length > 40 && !description.contains("\n")
                        ? TextAlign.start
                        : TextAlign.center,
                  ),
                ),
              ),
            ),
          );
  }

  Widget? _buildErrorMessage(CurrencyState currencyState) {
    final validationError = PaymentValidator(
      validatePayment: context.read<AccountBloc>().validatePayment,
      currency: currencyState.bitcoinCurrency,
      channelCreationPossible: context.read<LSPBloc>().state?.isChannelOpeningAvailable ?? false,
      texts: context.texts(),
    ).validateOutgoing(_amountToPaySat(currencyState));
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
          color: themeData.isLightTheme ? Colors.red : themeData.colorScheme.error,
        ),
      ),
    );
  }

  Widget _buildActions(CurrencyState currency, AccountState accState) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => widget._onCancel(),
        child: Text(texts.payment_request_dialog_action_cancel, style: themeData.primaryTextTheme.labelLarge),
      ),
    ];

    int toPaySat = _amountToPaySat(currency);
    if (toPaySat > 0 && accState.maxAllowedToPaySat >= toPaySat) {
      actions.add(
        SimpleDialogOption(
          onPressed: (() async {
            if (widget.invoice.amountMsat > 0 || _formKey.currentState!.validate()) {
              if (widget.invoice.amountMsat == 0) {
                _amountToPayMap["_amountToPaySat"] = toPaySat;
                _amountToPayMap["_amountToPayStr"] = BitcoinCurrency.fromTickerSymbol(
                  currency.bitcoinTicker,
                ).format(_amountToPaySat(currency));
                widget._setAmountToPay(_amountToPayMap);
                widget._onWaitingConfirmation();
              } else {
                widget._onPaymentApproved(widget.invoice.bolt11, _amountToPaySat(currency));
              }
            }
          }),
          child: Text(
            texts.payment_request_dialog_action_approve,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      );
    }
    return Theme(
      data: themeData.copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
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

  int _amountToPaySat(CurrencyState acc) {
    int amountSat = widget.invoice.amountMsat ~/ 1000;
    if (amountSat == 0) {
      try {
        amountSat = BitcoinCurrency.fromTickerSymbol(acc.bitcoinTicker).parse(_invoiceAmountController.text);
      } catch (_) {}
    }
    return amountSat;
  }
}

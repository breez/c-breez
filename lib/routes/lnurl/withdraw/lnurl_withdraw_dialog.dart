import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/lsp/lsp_bloc.dart';
import '../../../utils/payment_validator.dart';

class LNURLWithdrawDialog extends StatefulWidget {
  final LNURLWithdrawParams withdrawParams;
  final Function() onComplete;
  final Function(String error) onError;

  const LNURLWithdrawDialog(
    this.withdrawParams, {
    Key? key,
    required this.onComplete,
    required this.onError,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNURLWithdrawDialogState();
  }
}

class LNURLWithdrawDialogState extends State<LNURLWithdrawDialog> {
  final formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  bool _showFiatCurrency = false;
  late final bool fixedAmount;

  @override
  void initState() {
    fixedAmount = widget.withdrawParams.minWithdrawable ==
        widget.withdrawParams.maxWithdrawable;
    if (fixedAmount) {
      _amountController.text = (widget.withdrawParams.minWithdrawable ~/ 1000).toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;

    FiatConversion? fiatConversion;
    if (currencyState.fiatEnabled) {
      fiatConversion = FiatConversion(
          currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);
    }

    return AlertDialog(
      title: Text(
        widget.withdrawParams.domain,
        style: Theme.of(context)
            .primaryTextTheme
            .headline4!
            .copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                texts.sweep_all_coins_label_receive,
                style: themeData.primaryTextTheme.headline3!
                    .copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              if (fixedAmount) ...[
                GestureDetector(
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
                          ? fiatConversion.format(Int64(
                              widget.withdrawParams.maxWithdrawable ~/ 1000))
                          : BitcoinCurrency.fromTickerSymbol(
                                  currencyState.bitcoinTicker)
                              .format(Int64(
                                  widget.withdrawParams.maxWithdrawable ~/
                                      1000)),
                      style: themeData.primaryTextTheme.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
              if (!fixedAmount) ...[
                Theme(
                  data: themeData.copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: theme.greyBorderSide,
                      ),
                    ),
                    hintColor: themeData.dialogTheme.contentTextStyle!.color,
                    colorScheme: ColorScheme.dark(
                      primary: themeData.textTheme.button!.color!,
                    ),
                    primaryColor: themeData.textTheme.button!.color!,
                    errorColor: theme.themeId == "BLUE"
                        ? Colors.red
                        : themeData.errorColor,
                  ),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AmountFormField(
                          context: context,
                          texts: texts,
                          bitcoinCurrency: currencyState.bitcoinCurrency,
                          controller: _amountController,
                          validatorFn: validatePayment,
                          onFieldSubmitted: (_) {
                            formKey.currentState?.validate();
                          },
                          style: themeData.dialogTheme.contentTextStyle!
                              .copyWith(height: 1.0),
                          iconColor: themeData.primaryIconTheme.color,
                        ),
                        AutoSizeText(
                          '${texts.lnurl_fetch_invoice_limit(
                            (widget.withdrawParams.minWithdrawable ~/ 1000)
                                .toString(),
                            (widget.withdrawParams.maxWithdrawable ~/ 1000)
                                .toString(),
                          )} sats.',
                          maxLines: 2,
                          style: themeData.dialogTheme.contentTextStyle,
                          minFontSize: MinFontSize(context).minFontSize,
                        ),
                      ]),
                ),
              ],
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    minWidth: double.infinity,
                  ),
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: AutoSizeText(
                        widget.withdrawParams.defaultDescription,
                        style: themeData.primaryTextTheme.headline3!
                            .copyWith(fontSize: 16),
                        textAlign:
                            widget.withdrawParams.defaultDescription.length >
                                        40 &&
                                    !widget.withdrawParams.defaultDescription
                                        .contains("\n")
                                ? TextAlign.start
                                : TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            ]),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              return Theme.of(context)
                  .textTheme
                  .button!
                  .color!; // Defer to the widget's default.
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onComplete();
          },
          child: Text(
            texts.lnurl_withdraw_dialog_action_close,
            style: themeData.primaryTextTheme.button,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              return Theme.of(context)
                  .textTheme
                  .button!
                  .color!; // Defer to the widget's default.
            }),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final AccountBloc accountBloc = context.read<AccountBloc>();

              // Create loader and process payment
              final navigator = Navigator.of(context);
              navigator.pop();
              var loaderRoute = createLoaderRoute(context);
              navigator.push(loaderRoute);
              Invoice invoice = await accountBloc.addInvoice(
                description: widget.withdrawParams.defaultDescription,
                amount: Int64.parseInt(_amountController.text),
              );
              Map<String, String> qParams = {
                'k1': widget.withdrawParams.k1.toString(),
                'pr': invoice.bolt11
              };
              bool isSent = await accountBloc
                  .processLNURLWithdraw(widget.withdrawParams, qParams)
                  .onError(
                (error, stackTrace) {
                  navigator.removeRoute(loaderRoute);
                  widget.onComplete();
                  return widget.onError(error.toString());
                },
              );
              navigator.removeRoute(loaderRoute);
              widget.onComplete();
              if (!isSent) {
                String error =
                    texts.lnurl_withdraw_dialog_error('').replaceAll(':', '');
                widget.onError(error);
              }
            }
          },
          child: Text(
            texts.bottom_action_bar_receive,
            style: themeData.primaryTextTheme.button,
          ),
        ),
      ],
    );
  }

  String? validatePayment(Int64 amount) {
    var accBloc = context.read<AccountBloc>();
    late final lspStatus = context.read<LSPBloc>().state;
    late final currencyState = context.read<CurrencyBloc>().state;

    if (amount > (widget.withdrawParams.maxWithdrawable ~/ 1000)) {
      return "Exceeds maximum withdrawable amount: ${widget.withdrawParams.maxWithdrawable ~/ 1000}";
    }
    if (amount < (widget.withdrawParams.minWithdrawable ~/ 1000)) {
      return "Below minimum withdrawable amount: ${widget.withdrawParams.minWithdrawable ~/ 1000}";
    }

    Int64? channelMinimumFee;
    if (lspStatus.currentLSP != null) {
      channelMinimumFee = Int64(
        lspStatus.currentLSP!.channelMinimumFeeMsat ~/ 1000,
      );
    }

    return PaymentValidator(
      accBloc.validatePayment,
      currencyState.bitcoinCurrency,
      channelMinimumFee: channelMinimumFee,
    ).validateIncoming(amount);
  }
}

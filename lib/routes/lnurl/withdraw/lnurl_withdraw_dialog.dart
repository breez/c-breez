import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/lnurl/withdraw/withdraw_response.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/lsp/lsp_bloc.dart';
import '../../../utils/payment_validator.dart';

final _log = FimberLog("LNURLWithdrawDialog");

class LNURLWithdrawDialog extends StatefulWidget {
  final sdk.LnUrlWithdrawRequestData requestData;
  final String domain;

  const LNURLWithdrawDialog({
    Key? key,
    required this.requestData,
    required this.domain,
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
    fixedAmount = widget.requestData.minWithdrawable ==
        widget.requestData.maxWithdrawable;
    if (fixedAmount) {
      _amountController.text =
          (widget.requestData.minWithdrawable ~/ 1000).toString();
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
        widget.domain,
        style: themeData.primaryTextTheme.headline4!.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
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
                            ? fiatConversion.format(
                                widget.requestData.maxWithdrawable ~/ 1000)
                            : BitcoinCurrency.fromTickerSymbol(
                                    currencyState.bitcoinTicker)
                                .format(
                                    widget.requestData.maxWithdrawable ~/ 1000),
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
                      primaryColor: themeData.textTheme.labelLarge!.color!,
                      colorScheme: ColorScheme.dark(
                        primary: themeData.textTheme.labelLarge!.color!,
                        error: themeData.isLightTheme
                            ? Colors.red
                            : themeData.colorScheme.error,
                      ),
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
                            texts.lnurl_fetch_invoice_limit(
                              (widget.requestData.minWithdrawable ~/ 1000)
                                  .toString(),
                              (widget.requestData.maxWithdrawable ~/ 1000)
                                  .toString(),
                            ),
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
                        child: Text(
                          widget.requestData.defaultDescription,
                          style: themeData.primaryTextTheme.headline3!
                              .copyWith(fontSize: 16),
                          textAlign:
                              widget.requestData.defaultDescription.length >
                                          40 &&
                                      !widget.requestData.defaultDescription
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
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              // Defer to the widget's default.
              return themeData.textTheme.labelLarge!.color!;
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            texts.lnurl_withdraw_dialog_action_close,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              // Defer to the widget's default.
              return themeData.textTheme.labelLarge!.color!;
            }),
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final AccountBloc accountBloc = context.read<AccountBloc>();
              final CurrencyBloc currencyBloc = context.read<CurrencyBloc>();

              // Create loader and process payment
              final navigator = Navigator.of(context);
              var loaderRoute = createLoaderRoute(context);
              navigator.push(loaderRoute);

              try {
                final amount = currencyBloc.state.bitcoinCurrency
                    .parse(_amountController.text);
                _log.v("LNURL withdraw of $amount sats where "
                    "min is ${widget.requestData.minWithdrawable} msats "
                    "and max is ${widget.requestData.maxWithdrawable} msats.");
                final resp = await accountBloc.lnurlWithdraw(
                  reqData: widget.requestData,
                  amountSats: amount,
                  description: widget.requestData.defaultDescription,
                );
                navigator.removeRoute(loaderRoute);
                if (resp is sdk.LnUrlWithdrawCallbackStatus_Ok) {
                  _log.v("LNURL withdraw success");
                  navigator.pop(LNURLWithdrawPageResult());
                } else if (resp
                    is sdk.LnUrlWithdrawCallbackStatus_ErrorStatus) {
                  _log.v("LNURL withdraw failed: ${resp.data.reason}");
                  navigator.pop(LNURLWithdrawPageResult(
                    error: resp.data.reason,
                  ));
                } else {
                  _log.w("Unknown response from lnurlWithdraw: $resp");
                  navigator.pop(LNURLWithdrawPageResult(
                    error: texts.lnurl_payment_page_unknown_error,
                  ));
                }
              } catch (e) {
                _log.w("Error withdrawing LNURL payment", ex: e);
                navigator.removeRoute(loaderRoute);
                navigator.pop(
                  LNURLWithdrawPageResult(
                    error: texts.lnurl_withdraw_dialog_error_unknown,
                  ),
                );
              }
            }
          },
          child: Text(
            texts.bottom_action_bar_receive,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  String? validatePayment(int amount) {
    final texts = context.texts();
    final accBloc = context.read<AccountBloc>();
    final lspInfo = context.read<LSPBloc>().state?.lspInfo;
    final currencyState = context.read<CurrencyBloc>().state;

    final maxSats = widget.requestData.maxWithdrawable ~/ 1000;
    if (amount > maxSats) {
      return texts.lnurl_withdraw_dialog_error_amount_exceeds(maxSats);
    }
    final minSats = widget.requestData.minWithdrawable ~/ 1000;
    if (amount < minSats) {
      return texts.lnurl_withdraw_dialog_error_amount_below(minSats);
    }

    int? channelMinimumFee;
    if (lspInfo != null) {
      channelMinimumFee = lspInfo.channelMinimumFeeMsat ~/ 1000;
    }

    return PaymentValidator(
      accBloc.validatePayment,
      currencyState.bitcoinCurrency,
      channelMinimumFee: channelMinimumFee,
      texts: context.texts(),
    ).validateIncoming(amount);
  }
}

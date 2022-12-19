import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("LNURLPaymentDialog");

class LNURLPaymentDialog extends StatefulWidget {
  final sdk.LnUrlPayRequestData requestData;
  final String domain;

  const LNURLPaymentDialog({
    required this.requestData,
    required this.domain,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNURLPaymentDialogState();
  }
}

class LNURLPaymentDialogState extends State<LNURLPaymentDialog> {
  bool _showFiatCurrency = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;
    final metadataMap = {
      for (var v in json.decode(widget.requestData.metadataStr)) v[0] as String: v[1],
    };
    final description = metadataMap['text/long-desc'] ?? metadataMap['text/plain'];
    FiatConversion? fiatConversion;
    if (currencyState.fiatEnabled) {
      fiatConversion = FiatConversion(
        currencyState.fiatCurrency!,
        currencyState.fiatExchangeRate!,
      );
    }

    return AlertDialog(
      title: Text(
        widget.domain,
        style: themeData.primaryTextTheme.headline4!.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texts.payment_request_dialog_requesting,
            style: themeData.primaryTextTheme.headline3!.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
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
                    ? fiatConversion.format(widget.requestData.maxSendable ~/ 1000)
                    : BitcoinCurrency.fromTickerSymbol(currencyState.bitcoinTicker)
                        .format(widget.requestData.maxSendable ~/ 1000),
                style: themeData.primaryTextTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
                minWidth: double.infinity,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: themeData.primaryTextTheme.headline3!.copyWith(
                      fontSize: 16,
                    ),
                    textAlign:
                        description.length > 40 && !description.contains("\n") ? TextAlign.start : TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              // Defer to the widget's default.
              return themeData.textTheme.button!.color!;
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            texts.payment_request_dialog_action_cancel,
            style: themeData.primaryTextTheme.button,
          ),
        ),
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.transparent;
              }
              // Defer to the widget's default.
              return themeData.textTheme.button!.color!;
            }),
          ),
          onPressed: () async {
            final AccountBloc accountBloc = context.read<AccountBloc>();
            final navigator = Navigator.of(context);
            var loaderRoute = createLoaderRoute(context);
            navigator.push(loaderRoute);

            try {
              final amount = widget.requestData.maxSendable ~/ 1000;
              _log.v("LNURL payment of $amount sats where "
                  "min is ${widget.requestData.minSendable} msats "
                  "and max is ${widget.requestData.maxSendable} mstas.");
              final resp = await accountBloc.sendLNURLPayment(
                amount: amount,
                reqData: widget.requestData,
              );
              navigator.removeRoute(loaderRoute);
              if (resp is sdk.LnUrlPayResult_EndpointSuccess) {
                _log.v("LNURL payment success, action: ${resp.field0}");
                navigator.pop(LNURLPaymentPageResult(
                  successAction: resp.field0,
                ));
              } else if (resp is sdk.LnUrlPayResult_EndpointError) {
                _log.v("LNURL payment failed: ${resp.field0.reason}");
                navigator.pop(LNURLPaymentPageResult(
                  error: resp.field0.reason,
                ));
              } else {
                _log.w("Unknown response from sendLNURLPayment: $resp");
                navigator.pop(LNURLPaymentPageResult(
                  error: texts.lnurl_payment_page_unknown_error,
                ));
              }
            } catch (e) {
              _log.w("Error sending LNURL payment: $e");
              navigator.removeRoute(loaderRoute);
              navigator.pop(LNURLPaymentPageResult(error: e));
            }
          },
          child: Text(
            texts.spontaneous_payment_action_pay,
            style: themeData.primaryTextTheme.button,
          ),
        ),
      ],
    );
  }
}

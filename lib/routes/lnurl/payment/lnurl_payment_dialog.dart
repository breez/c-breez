import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("LNURLPaymentDialog");

class LNURLPaymentDialog extends StatefulWidget {
  final sdk.LnUrlPayRequestData requestData;

  const LNURLPaymentDialog({
    required this.requestData,
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
        Uri.parse(widget.requestData.callback).host,
        style: themeData.primaryTextTheme.headlineMedium!.copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            texts.payment_request_dialog_requesting,
            style: themeData.primaryTextTheme.displaySmall!.copyWith(fontSize: 16),
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
                style: themeData.primaryTextTheme.headlineSmall,
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
                    style: themeData.primaryTextTheme.displaySmall!.copyWith(
                      fontSize: 16,
                    ),
                    textAlign: description.length > 40 && !description.contains("\n")
                        ? TextAlign.start
                        : TextAlign.center,
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
              return themeData.textTheme.labelLarge!.color!;
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            texts.payment_request_dialog_action_cancel,
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
          onPressed: () {
            final amount = widget.requestData.maxSendable ~/ 1000;
            _log.v("LNURL payment of $amount sats where "
                "min is ${widget.requestData.minSendable} msats "
                "and max is ${widget.requestData.maxSendable} msats.");
            Navigator.pop(context, LNURLPaymentInfo(amount: amount));
          },
          child: Text(
            texts.spontaneous_payment_action_pay,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

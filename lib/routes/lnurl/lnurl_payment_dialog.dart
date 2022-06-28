import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LNURLPaymentDialog extends StatefulWidget {
  final LNURLPayParams payParams;
  final Function() onComplete;
  final Function() onCancel;

  const LNURLPaymentDialog(
    this.payParams, {
    required this.onComplete,
    required this.onCancel,
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
      for (var v in json.decode(widget.payParams.metadata)) v[0] as String: v[1]
    };
    final description =
        metadataMap['text/long-desc'] ?? metadataMap['text/plain'];
    FiatConversion? fiatConversion;
    if (currencyState.fiatEnabled) {
      fiatConversion = FiatConversion(
          currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);
    }

    return AlertDialog(
      title: Text(
        widget.payParams.domain,
        style: Theme.of(context)
            .primaryTextTheme
            .headline4!
            .copyWith(fontSize: 16),
        textAlign: TextAlign.center,
      ),
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texts.payment_request_dialog_requesting,
              style:
                  themeData.primaryTextTheme.headline3!.copyWith(fontSize: 16),
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
                      ? fiatConversion
                          .format(Int64(widget.payParams.maxSendable ~/ 1000))
                      : BitcoinCurrency.fromTickerSymbol(
                              currencyState.bitcoinTicker)
                          .format(Int64(widget.payParams.maxSendable ~/ 1000)),
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
                    child: AutoSizeText(
                      description,
                      style: themeData.primaryTextTheme.headline3!
                          .copyWith(fontSize: 16),
                      textAlign:
                          description.length > 40 && !description.contains("\n")
                              ? TextAlign.start
                              : TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          ]),
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
            widget.onCancel();
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
              return Theme.of(context)
                  .textTheme
                  .button!
                  .color!; // Defer to the widget's default.
            }),
          ),
          onPressed: () {
            Navigator.of(context).pop;
            widget.onComplete();
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

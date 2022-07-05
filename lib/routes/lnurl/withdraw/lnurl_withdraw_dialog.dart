import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/utils/fiat_conversion.dart';

import 'package:c_breez/widgets/loader.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LNURLWithdrawDialog extends StatefulWidget {
  final LNURLWithdrawParams withdrawParams;
  final Function() onComplete;

  const LNURLWithdrawDialog(
    this.withdrawParams, {
    required this.onComplete,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNURLWithdrawDialogState();
  }
}

class LNURLWithdrawDialogState extends State<LNURLWithdrawDialog> {
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
      content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texts.sweep_all_coins_label_receive,
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
                      ? fiatConversion.format(
                          Int64(widget.withdrawParams.maxWithdrawable ~/ 1000))
                      : BitcoinCurrency.fromTickerSymbol(
                              currencyState.bitcoinTicker)
                          .format(
                              Int64(widget.withdrawParams.maxWithdrawable ~/ 1000)),
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
            final AccountBloc accountBloc = context.read<AccountBloc>();

            // Create loader and process payment
            final navigator = Navigator.of(context);
            navigator.pop();
            var loaderRoute = createLoaderRoute(context);
            navigator.push(loaderRoute);
            Map<String, String> qParams = {
              'k1': widget.withdrawParams.k1.toString(),
              'pr': widget.withdrawParams.pr
            };
            await accountBloc
                .processLNURLWithdraw(widget.withdrawParams, qParams)
                .onError(
              (error, stackTrace) {
                navigator.removeRoute(loaderRoute);
                widget.onComplete();
                throw Exception(error.toString());
              },
            );
            navigator.removeRoute(loaderRoute);
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

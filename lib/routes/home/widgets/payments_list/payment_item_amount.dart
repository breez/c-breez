import 'dart:io';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PaymentItemAmount extends StatelessWidget {
  final LightningTransaction _paymentInfo;
  final bool _hideBalance;

  const PaymentItemAmount(
    this._paymentInfo,
    this._hideBalance, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return SizedBox(
      height: 44,
      child: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, currencyState) {
          final fee = _paymentInfo.feesMsat ~/ 1000;
          final amount = currencyState.bitcoinCurrency.format(
            _paymentInfo.amountMsat ~/ 1000,
            includeDisplayName: false,
          );
          final feeFormatted = currencyState.bitcoinCurrency.format(
            fee,
            includeDisplayName: false,
          );

          return Column(
            mainAxisAlignment:
                _paymentInfo.feesMsat == 0 || _paymentInfo.pending
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _hideBalance
                    ? texts.wallet_dashboard_payment_item_balance_hide
                    : _paymentInfo.paymentType == "received"
                        ? texts.wallet_dashboard_payment_item_balance_positive(
                            amount)
                        : texts.wallet_dashboard_payment_item_balance_negative(
                            amount),
                style: themeData.paymentItemAmountTextStyle,
              ),
              (fee == 0 || _paymentInfo.pending)
                  ? const SizedBox()
                  : Text(
                      _hideBalance
                          ? texts.wallet_dashboard_payment_item_balance_hide
                          : texts.wallet_dashboard_payment_item_balance_fee(feeFormatted),
                      style: themeData.paymentItemFeeTextStyle,
                    ),
            ],
          );
        },
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: Directory(
      join((await getApplicationDocumentsDirectory()).path, "preview_storage"),
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CurrencyBloc>(
          create: (BuildContext context) =>
              CurrencyBloc(ServiceInjector().breezLib),
        ),
      ],
      child: MaterialApp(
        theme: breezLightTheme,
        home: Column(children: [
          PaymentItemAmount(
            LightningTransaction(
              paymentType: "received",
              label: "",
              bolt11: "",
              destinationPubkey:
                  "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              paymentHash:
                  "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feesMsat: 0,
              keysend: false,
              paymentPreimage: "",
              paymentTime: 1661791810,
              amountMsat: 4321000,
              pending: false,
              description: "",
            ),
            false,
          ),

          // Pending
          PaymentItemAmount(
            LightningTransaction(
              paymentType: "received",
              label: "",
              bolt11: "",
              destinationPubkey:
                  "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              paymentHash:
                  "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feesMsat: 1234,
              keysend: false,
              paymentPreimage: "",
              paymentTime: 1661791810,
              amountMsat: 4321000,
              pending: true,
              description: "",
            ),
            false,
          ),

          // Show all
          PaymentItemAmount(
            LightningTransaction(
              paymentType: "received",
              label: "",
              bolt11: "",
              destinationPubkey:
                  "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              paymentHash:
                  "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feesMsat: 1234,
              keysend: false,
              paymentPreimage: "",
              paymentTime: 1661791810,
              amountMsat: 4321000,
              pending: false,
              description: "",
            ),
            false,
          ),

          // Hide all
          PaymentItemAmount(
            LightningTransaction(
              paymentType: "received",
              label: "",
              bolt11: "",
              destinationPubkey:
                  "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
              paymentHash:
                  "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
              feesMsat: 1234,
              keysend: false,
              paymentPreimage: "",
              paymentTime: 1661791810,
              amountMsat: 4321000,
              pending: false,
              description: "",
            ),
            true,
          ),
        ]),
      ),
    ),
  );
}

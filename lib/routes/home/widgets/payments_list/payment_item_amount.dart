import 'dart:io';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PaymentItemAmount extends StatelessWidget {
  final PaymentMinutiae _paymentMinutiae;

  const PaymentItemAmount(
    this._paymentMinutiae, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return SizedBox(
      height: 44,
      child: BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, userModel) {
        final bool hideBalance = userModel.profileSettings.hideBalance;
        return BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, currencyState) {
            final fee = _paymentMinutiae.feeSat;
            final amount = currencyState.bitcoinCurrency.format(
              _paymentMinutiae.amountSat,
              includeDisplayName: false,
            );
            final feeFormatted = currencyState.bitcoinCurrency.format(
              fee,
              includeDisplayName: false,
            );

            return Column(
              mainAxisAlignment:
                  _paymentMinutiae.feeMilliSat == 0 || _paymentMinutiae.status == PaymentStatus.Pending
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hideBalance
                      ? texts.wallet_dashboard_payment_item_balance_hide
                      : _paymentMinutiae.paymentType == PaymentType.Received
                          ? texts.wallet_dashboard_payment_item_balance_positive(amount)
                          : texts.wallet_dashboard_payment_item_balance_negative(amount),
                  style: themeData.paymentItemAmountTextStyle,
                ),
                (fee == 0 || _paymentMinutiae.status == PaymentStatus.Pending)
                    ? const SizedBox()
                    : Text(
                        hideBalance
                            ? texts.wallet_dashboard_payment_item_balance_hide
                            : texts.wallet_dashboard_payment_item_balance_fee(feeFormatted),
                        style: themeData.paymentItemFeeTextStyle,
                      ),
              ],
            );
          },
        );
      }),
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
          create: (BuildContext context) => CurrencyBloc(ServiceInjector().breezSDK),
        ),
      ],
      child: MaterialApp(
        theme: breezLightTheme,
        home: Column(
          children: [
            PaymentItemAmount(
              PaymentMinutiae.fromPayment(
                const Payment(
                  paymentType: PaymentType.Received,
                  id: "",
                  feeMsat: 0,
                  paymentTime: 1661791810,
                  amountMsat: 4321000,
                  status: PaymentStatus.Complete,
                  description: "",
                  details: PaymentDetails.ln(
                    data: LnPaymentDetails(
                      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                      label: "",
                      destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                      paymentPreimage: "",
                      keysend: false,
                      bolt11: "",
                    ),
                  ),
                ),
                getSystemAppLocalizations(),
                800000,
              ),
            ),

            // Pending
            PaymentItemAmount(
              PaymentMinutiae.fromPayment(
                const Payment(
                  paymentType: PaymentType.Received,
                  id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                  feeMsat: 1234,
                  paymentTime: 1661791810,
                  amountMsat: 4321000,
                  status: PaymentStatus.Pending,
                  description: "",
                  details: PaymentDetails.ln(
                    data: LnPaymentDetails(
                      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                      label: "",
                      destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                      paymentPreimage: "",
                      keysend: false,
                      bolt11: "",
                    ),
                  ),
                ),
                getSystemAppLocalizations(),
                800000,
              ),
            ),

            // Show all
            PaymentItemAmount(
              PaymentMinutiae.fromPayment(
                const Payment(
                  paymentType: PaymentType.Received,
                  id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                  feeMsat: 1234,
                  paymentTime: 1661791810,
                  amountMsat: 4321000,
                  status: PaymentStatus.Complete,
                  description: "",
                  details: PaymentDetails.ln(
                    data: LnPaymentDetails(
                      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                      label: "",
                      destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                      paymentPreimage: "",
                      keysend: false,
                      bolt11: "",
                    ),
                  ),
                ),
                getSystemAppLocalizations(),
                800000,
              ),
            ),

            // Hide all
            PaymentItemAmount(
              PaymentMinutiae.fromPayment(
                const Payment(
                  paymentType: PaymentType.Received,
                  id: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                  feeMsat: 1234,
                  paymentTime: 1661791810,
                  amountMsat: 4321000,
                  status: PaymentStatus.Complete,
                  description: "",
                  details: PaymentDetails.ln(
                    data: LnPaymentDetails(
                      paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                      label: "",
                      destinationPubkey: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                      paymentPreimage: "",
                      keysend: false,
                      bolt11: "",
                    ),
                  ),
                ),
                getSystemAppLocalizations(),
                800000,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

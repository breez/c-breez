import 'dart:io';

import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/firebase_options.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payment_item.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const _kBottomPadding = 8.0;

class PaymentsList extends StatelessWidget {
  final List<PaymentInfo> _payments;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;

  const PaymentsList(
    this._payments,
    this._itemHeight,
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userModel) {
        return SliverFixedExtentList(
          itemExtent: _itemHeight + _kBottomPadding,
          delegate: SliverChildBuilderDelegate(
            (context, index) => PaymentItem(
              _payments[index],
              0 == index,
              userModel.profileSettings.hideBalance,
              firstPaymentItemKey,
            ),
            childCount: _payments.length,
          ),
        );
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firstPaymentItemKey = GlobalKey();
  final injector = ServiceInjector();
  HydratedBlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<CurrencyBloc>(
            create: (BuildContext context) =>
                CurrencyBloc(injector.fiatService),
          ),
          BlocProvider<UserProfileBloc>(
            create: (BuildContext context) => UserProfileBloc(injector.breezServer, injector.notifications),
          ),
        ],
        child: MaterialApp(
          theme: breezLightTheme,
          home: Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                controller: ScrollController(),
                slivers: [
                  PaymentsList(
                    [
                      PaymentInfo(
                        type: PaymentType.received,
                        amountMsat: Int64(4321000),
                        feeMsat: Int64(0),
                        creationTimestamp: Int64(1661791810),
                        pending: false,
                        keySend: false,
                        paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                        preimage: null,
                        destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                        pendingExpirationTimestamp: null,
                        description: "A title",
                        longTitle: "A long title",
                        shortTitle: "",
                        imageURL: null,
                      ),
                      PaymentInfo(
                        type: PaymentType.received,
                        amountMsat: Int64(4321000),
                        feeMsat: Int64(12),
                        creationTimestamp: Int64(1661791810),
                        pending: false,
                        keySend: false,
                        paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                        preimage: null,
                        destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                        pendingExpirationTimestamp: null,
                        description: "A title",
                        longTitle: "A long title",
                        shortTitle: "",
                        imageURL: null,
                      ),
                      PaymentInfo(
                        type: PaymentType.received,
                        amountMsat: Int64(4321000),
                        feeMsat: Int64(3456),
                        creationTimestamp: Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000),
                        pending: false,
                        keySend: false,
                        paymentHash: "7afeee37f0bb1578e94f2e406973118c4dcec0e0755aa873af4a9a24473c02de",
                        preimage: null,
                        destination: "0264a67069b7cbd4ea3db0709d9f605e11643a66fe434d77eaf9bf960a323dda5d",
                        pendingExpirationTimestamp: null,
                        description: "A title",
                        longTitle: "A long title",
                        shortTitle: "",
                        imageURL: null,
                      ),
                    ],
                    72,
                    firstPaymentItemKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    storage: await HydratedStorage.build(
      storageDirectory: Directory(join((await getApplicationDocumentsDirectory()).path, "preview_storage")),
    ),
  );
}

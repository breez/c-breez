import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/routes/payment_options/widget/actions_fee.dart';
import 'package:c_breez/routes/payment_options/widget/exempt_fee_widget.dart';
import 'package:c_breez/routes/payment_options/widget/header_fee.dart';
import 'package:c_breez/routes/payment_options/widget/override_fee.dart';
import 'package:c_breez/routes/payment_options/widget/proportional_fee_widget.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentOptionsPage extends StatelessWidget {
  const PaymentOptionsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final bloc = context.read<PaymentOptionsBloc>();

    return WillPopScope(
      onWillPop: () => bloc.cancelEditing().then((_) => true),
      child: Scaffold(
        appBar: AppBar(
          key: GlobalKey<ScaffoldState>(),
          leading: back_button.BackButton(
            onPressed: () => bloc.cancelEditing().then((_) => Navigator.pop(context)),
          ),
          title: Text(
            texts.payment_options_title,
            style: themeData.appBarTheme.toolbarTextStyle,
          ),
        ),
        body: ListView(
          children: const [
            HeaderFee(),
            OverrideFee(),
            ExemptfeeMsatWidget(),
            ProportionalFeeWidget(),
            ActionsFee(),
          ],
        ),
      ),
    );
  }
}

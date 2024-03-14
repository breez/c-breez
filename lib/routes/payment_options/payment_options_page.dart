import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/payment_options/widget/actions_fee.dart';
import 'package:c_breez/routes/payment_options/widget/header_fee.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:flutter/material.dart';

import 'payment_options_form.dart';

class PaymentOptionsPage extends StatefulWidget {
  const PaymentOptionsPage({
    super.key,
  });

  @override
  State<PaymentOptionsPage> createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        key: GlobalKey<ScaffoldState>(),
        leading: const back_button.BackButton(),
        title: Text(
          texts.payment_options_title,
          style: themeData.appBarTheme.toolbarTextStyle,
        ),
      ),
      body: ListView(
        children: [
          const HeaderFee(),
          PaymentOptionsForm(formKey: _formKey),
          ActionsFee(formKey: _formKey),
        ],
      ),
    );
  }
}

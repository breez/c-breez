import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/widgets/address_widget.dart';
import 'package:c_breez/widgets/receivable_btc_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LnAddressWidget extends StatefulWidget {
  final String lnurlPayUrl;

  const LnAddressWidget(this.lnurlPayUrl, {super.key});

  @override
  State<LnAddressWidget> createState() => _LnAddressWidgetState();
}

class _LnAddressWidgetState extends State<LnAddressWidget> {
  @override
  Widget build(BuildContext context) {
    final channelFeeLimitMsat = context.read<PaymentOptionsBloc>().state.channelFeeLimitMsat;
    final texts = context.texts();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddressWidget(
          widget.lnurlPayUrl,
          title: texts.invoice_ln_address_address_information,
          type: AddressWidgetType.lnurl,
          footer: widget.lnurlPayUrl,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: ReceivableBTCBox(channelFeeLimitSat: channelFeeLimitMsat ~/ 1000),
        ),
      ],
    );
  }
}
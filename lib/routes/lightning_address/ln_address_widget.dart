import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/widgets/address_widget.dart';
import 'package:c_breez/widgets/ln_fee_message.dart';
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
    final texts = context.texts();

    final lspState = context.watch<LSPBloc>().state;
    final isChannelOpeningAvailable = lspState?.isChannelOpeningAvailable ?? false;
    final openingFeeParams = lspState?.lspInfo?.openingFeeParamsList.values.first;
    final channelFeeLimitMsat = context.read<PaymentOptionsBloc>().state.channelFeeLimitMsat;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddressWidget(
          widget.lnurlPayUrl,
          title: texts.invoice_ln_address_address_information,
          type: AddressWidgetType.lnurl,
        ),
        isChannelOpeningAvailable
            ? LnFeeMessage(
                openingFeeParams: openingFeeParams!,
                channelFeeLimitSat: channelFeeLimitMsat ~/ 1000,
              )
            : const SizedBox(),
      ],
    );
  }
}

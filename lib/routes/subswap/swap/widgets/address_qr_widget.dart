import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/create_invoice/widgets/compact_qr_image.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

import 'subswap_dialog.dart';

class AddressQRWidget extends StatelessWidget {
  final String address;
  final String backupJson;

  const AddressQRWidget({
    super.key,
    required this.address,
    required this.backupJson,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Column(
      children: [
        GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(top: 32.0, bottom: 16.0),
            padding: const EdgeInsets.all(8.6),
            child: CompactQRImage(
              data: "bitcoin:$address",
              size: 180.0,
            ),
          ),
          onLongPress: () => showDialog(
            useRootNavigator: false,
            context: context,
            builder: (_) => SwapDialog(backupJson: backupJson),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 16.0, left: 24, right: 24),
          child: GestureDetector(
            onTap: () {
              ServiceInjector().device.setClipboardText(address);
              showFlushbar(
                context,
                message: texts.invoice_btc_address_deposit_address_copied,
              );
            },
            child: Text(
              address,
              style: themeData.primaryTextTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}

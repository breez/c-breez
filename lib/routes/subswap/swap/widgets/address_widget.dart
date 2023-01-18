import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:c_breez/routes/subswap/swap/widgets/address_qr_widget.dart';
import 'package:share_plus/share_plus.dart';

class AddressWidget extends StatelessWidget {
  final String address;
  final String backupJson;

  const AddressWidget(this.address, {required this.backupJson});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AddressHeaderWidget(address: address),
        AddressQRWidget(address: address, backupJson: backupJson),
      ],
    );
  }
}

class AddressHeaderWidget extends StatelessWidget {
  final String address;

  const AddressHeaderWidget({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            texts.invoice_btc_address_deposit_address,
            style: theme.FieldTextStyle.labelStyle,
          ),
          Row(
            children: [
              _ShareIcon(address: address),
              _CopyIcon(address: address),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final String address;

  const _ShareIcon({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(IconData(0xe917, fontFamily: 'icomoon')),
      onPressed: () {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        final offset = box != null ? box.localToGlobal(Offset.zero) & box.size : Rect.zero;
        final rect = Rect.fromPoints(
          offset.topLeft,
          offset.bottomRight,
        );
        Share.share(
          address,
          sharePositionOrigin: rect,
        );
      },
    );
  }
}

class _CopyIcon extends StatelessWidget {
  final String address;

  const _CopyIcon({
    Key? key,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return IconButton(
      icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
      onPressed: () {
        ServiceInjector().device.setClipboardText(address);
        showFlushbar(
          context,
          message: texts.invoice_btc_address_deposit_address_copied,
        );
      },
    );
  }
}

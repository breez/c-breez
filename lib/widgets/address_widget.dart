import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/address_qr_widget.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

enum AddressWidgetType { bitcoin, lnurl }

class AddressWidget extends StatelessWidget {
  final String address;
  final String? footer;
  final String? title;
  final void Function()? onLongPress;
  final AddressWidgetType type;

  const AddressWidget(
    this.address, {
    this.footer,
    this.title,
    this.onLongPress,
    this.type = AddressWidgetType.bitcoin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AddressHeaderWidget(address: address, title: title),
        AddressQRWidget(address: address, footer: footer, onLongPress: onLongPress, type: type),
      ],
    );
  }
}

class AddressHeaderWidget extends StatelessWidget {
  final String address;
  final String? title;

  const AddressHeaderWidget({super.key, this.title, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? "", style: theme.FieldTextStyle.labelStyle),
          Row(
            children: [
              _ShareIcon(title: title, address: address),
              _CopyIcon(address: address),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final String? title;
  final String address;

  const _ShareIcon({required this.title, required this.address});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(IconData(0xe917, fontFamily: 'icomoon')),
      onPressed: () {
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        final offset = box != null ? box.localToGlobal(Offset.zero) & box.size : Rect.zero;
        final rect = Rect.fromPoints(offset.topLeft, offset.bottomRight);
        final ShareParams shareParams = ShareParams(title: title, text: address, sharePositionOrigin: rect);
        SharePlus.instance.share(shareParams);
      },
    );
  }
}

class _CopyIcon extends StatelessWidget {
  final String address;

  const _CopyIcon({required this.address});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return IconButton(
      icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
      onPressed: () {
        ServiceInjector().deviceClient.setClipboardText(address);
        showFlushbar(context, message: texts.invoice_btc_address_deposit_address_copied);
      },
    );
  }
}

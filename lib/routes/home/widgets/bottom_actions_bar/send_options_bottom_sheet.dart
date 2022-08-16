import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_action_item_image.dart';
import 'enter_payment_info_dialog.dart';

class SendOptionsBottomSheet extends StatelessWidget {
  final bool connected;
  final GlobalKey firstPaymentItemKey;

  const SendOptionsBottomSheet(
      {super.key, required this.connected, required this.firstPaymentItemKey});

  @override
  Widget build(BuildContext context) {
    final inputBloc = context.read<InputBloc>();
    final texts = context.texts();

    return StreamBuilder<DecodedClipboardData>(
      stream: inputBloc.decodedClipboardStream,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            ListTile(
              enabled: connected,
              leading: BottomActionItemImage(
                iconAssetPath: "src/icon/paste.png",
                enabled: connected,
              ),
              title: Text(
                texts.bottom_action_bar_paste_invoice,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _pasteTapped(
                  context, inputBloc, snapshot.data, firstPaymentItemKey),
            ),
            Divider(
              height: 0.0,
              color: Colors.white.withOpacity(0.2),
              indent: 72.0,
            ),
            ListTile(
              enabled: connected,
              leading: BottomActionItemImage(
                iconAssetPath: "src/icon/connect_to_pay.png",
                enabled: connected,
              ),
              title: Text(
                texts.bottom_action_bar_connect_to_pay,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(context, "/connect_to_pay"),
            ),
            Divider(
              height: 0.0,
              color: Colors.white.withOpacity(0.2),
              indent: 72.0,
            ),
            ListTile(
              enabled: connected,
              leading: BottomActionItemImage(
                iconAssetPath: "src/icon/bitcoin.png",
                enabled: connected,
              ),
              title: Text(
                texts.bottom_action_bar_send_btc_address,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(context, "/withdraw_funds"),
            ),
            const SizedBox(height: 8.0)
          ],
        );
      },
    );
  }

  void _pasteTapped(
    BuildContext context,
    InputBloc inputBloc,
    DecodedClipboardData? clipboardData,
    GlobalKey firstPaymentItemKey,
  ) async {
    Navigator.of(context).pop();
    if (clipboardData != null) {
      final data = clipboardData.data;
      if (clipboardData.type == ClipboardDataType.paymentRequest) {
        inputBloc.addIncomingInput(data ?? "");
      } else if (clipboardData.type == ClipboardDataType.nodeID) {
        Navigator.of(context).push(FadeInRoute(
          builder: (_) => SpontaneousPaymentPage(data, firstPaymentItemKey),
        ));
      }
    } else {
      await showDialog(
        useRootNavigator: false,
        context: context,
        barrierDismissible: false,
        builder: (_) => EnterPaymentInfoDialog(
          context,
          inputBloc,
          firstPaymentItemKey,
        ),
      );
    }
  }

  void _push(BuildContext context, String route) {
    final navigatorState = Navigator.of(context);
    navigatorState.pop();
    navigatorState.pushNamed(route);
  }
}

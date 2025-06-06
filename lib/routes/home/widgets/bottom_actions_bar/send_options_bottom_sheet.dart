import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_action_item_image.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/enter_payment_info_dialog.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendOptionsBottomSheet extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;

  const SendOptionsBottomSheet({super.key, required this.firstPaymentItemKey});

  @override
  State<SendOptionsBottomSheet> createState() => _SendOptionsBottomSheetState();
}

class _SendOptionsBottomSheetState extends State<SendOptionsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, account) {
        final hasBalance = account.balanceSat > 0;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            ListTile(
              enabled: hasBalance,
              leading: const BottomActionItemImage(iconAssetPath: "src/icon/paste.png"),
              title: Text(texts.bottom_action_bar_paste_invoice, style: theme.bottomSheetTextStyle),
              onTap: () => _showEnterPaymentInfoDialog(context, widget.firstPaymentItemKey),
            ),
            Divider(height: 0.0, color: Colors.white.withValues(alpha: 0.2), indent: 72.0),
            ListTile(
              enabled: hasBalance,
              leading: const BottomActionItemImage(iconAssetPath: "src/icon/bitcoin.png"),
              title: Text(texts.bottom_action_bar_send_btc_address, style: theme.bottomSheetTextStyle),
              onTap: () => _sendToBTCAddress(),
            ),
            const SizedBox(height: 8.0),
          ],
        );
      },
    );
  }

  Future<void> _showEnterPaymentInfoDialog(
    BuildContext context,
    GlobalKey<State<StatefulWidget>> firstPaymentItemKey,
  ) async {
    await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => EnterPaymentInfoDialog(paymentItemKey: firstPaymentItemKey),
    );
  }

  void _sendToBTCAddress() {
    final navigator = Navigator.of(context);
    // Close bottom sheet
    navigator.pop();
    // and open Send to BTC Address page
    navigator.pushNamed("/reverse_swap");
  }
}

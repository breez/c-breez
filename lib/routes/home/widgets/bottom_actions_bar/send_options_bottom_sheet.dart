import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_action_item_image.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/enter_payment_info_dialog.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendOptionsBottomSheet extends StatelessWidget {
  final bool isLspSelected;
  final GlobalKey firstPaymentItemKey;

  const SendOptionsBottomSheet({super.key, required this.isLspSelected, required this.firstPaymentItemKey});

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
            BlocBuilder<LSPBloc, LspState?>(
              buildWhen: (previous, current) => previous?.lspInfo != null || current?.lspInfo != null,
              builder: (context, lspState) {
                return ListTile(
                  enabled: isLspSelected,
                  leading: BottomActionItemImage(
                    iconAssetPath: "src/icon/paste.png",
                    enabled: isLspSelected,
                  ),
                  title: Text(
                    texts.bottom_action_bar_paste_invoice,
                    style: theme.bottomSheetTextStyle,
                  ),
                  onTap: () => _pasteTapped(context, inputBloc, snapshot.data, firstPaymentItemKey),
                );
              },
            ),
            Divider(
              height: 0.0,
              color: Colors.white.withOpacity(0.2),
              indent: 72.0,
            ),
            ListTile(
              enabled: false, // TODO: back to connected when we integrate with the SDK
              leading: BottomActionItemImage(
                iconAssetPath: "src/icon/bitcoin.png",
                enabled: isLspSelected,
              ),
              title: Text(
                texts.bottom_action_bar_send_btc_address,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(
                context,
                "/withdraw_funds",
                arguments: WithdrawKind.withdraw_funds,
              ),
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
    switch (clipboardData?.type) {
      case ClipboardDataType.lnurl:
      case ClipboardDataType.lightningAddress:
      case ClipboardDataType.paymentRequest:
        inputBloc.addIncomingInput(clipboardData!.data ?? "");
        return;
      case ClipboardDataType.nodeID:
        Navigator.of(context).push(
          FadeInRoute(
            builder: (_) => SpontaneousPaymentPage(
              clipboardData!.data,
              firstPaymentItemKey,
            ),
          ),
        );
        return;
      case ClipboardDataType.unrecognized:
      default:
        await showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: false,
          builder: (_) => EnterPaymentInfoDialog(paymentItemKey: firstPaymentItemKey),
        );
        return;
    }
  }

  void _push(BuildContext context, String route, {Object? arguments}) {
    final navigatorState = Navigator.of(context);
    navigatorState.pop();
    navigatorState.pushNamed(route, arguments: arguments);
  }
}

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/handlers/input_handler.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_action_item_image.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/enter_payment_info_dialog.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("SendOptionsBottomSheet");

class SendOptionsBottomSheet extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;
  final InputHandler inputHandler;

  const SendOptionsBottomSheet({
    super.key,
    required this.firstPaymentItemKey,
    required this.inputHandler,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8.0),
        BlocBuilder<InputBloc, InputState>(
          builder: (context, snapshot) {
            _log.v("Building paste item with snapshot: $snapshot");
            return ListTile(
              leading: const BottomActionItemImage(
                iconAssetPath: "src/icon/paste.png",
              ),
              title: Text(
                texts.bottom_action_bar_paste_invoice,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _pasteTapped(context, snapshot.inputData, firstPaymentItemKey),
            );
          },
        ),
        Divider(
          height: 0.0,
          color: Colors.white.withOpacity(0.2),
          indent: 72.0,
        ),
        BlocBuilder<AccountBloc, AccountState>(
          builder: (context, snapshot) {
            _log.v("Building send to address with snapshot: $snapshot");
            return ListTile(
              leading: const BottomActionItemImage(
                iconAssetPath: "src/icon/bitcoin.png",
              ),
              title: Text(
                texts.bottom_action_bar_send_btc_address,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(
                context,
                "/withdraw_funds",
                arguments: WithdrawFundsPolicy(
                  WithdrawKind.withdraw_funds,
                  0,
                  snapshot.balance,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8.0)
      ],
    );
  }

  /// This documentation is for clarification purposes.
  ///
  /// Even though this function is named paste tapped it assumes that the
  /// latest inputData on InputBloc's InputState comes from device's clipboard stream.
  /// Which is a good assumption because otherwise that inputData would've been handled.
  void _pasteTapped(
    BuildContext context,
    dynamic inputData,
    GlobalKey firstPaymentItemKey,
  ) async {
    // Close bottom sheet
    Navigator.of(context).pop();
    // and handle input data
    inputHandler.handleInputData(inputData).then((result) async {
      // If input data can't be handled(unsupported input type, empty device clipboard) display EnterPaymentInfoDialog
      if (result == false) {
        await showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: false,
          builder: (_) => EnterPaymentInfoDialog(paymentItemKey: firstPaymentItemKey),
        );
      } else {
        inputHandler.handleResult(result);
      }
    });
  }

  void _push(BuildContext context, String route, {Object? arguments}) {
    final navigatorState = Navigator.of(context);
    navigatorState.pop();
    navigatorState.pushNamed(route, arguments: arguments);
  }
}

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_action_item_image.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/enter_payment_info_dialog.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/loader.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("SendOptionsBottomSheet");

class SendOptionsBottomSheet extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;

  const SendOptionsBottomSheet({
    super.key,
    required this.firstPaymentItemKey,
  });

  @override
  State<SendOptionsBottomSheet> createState() => _SendOptionsBottomSheetState();
}

class _SendOptionsBottomSheetState extends State<SendOptionsBottomSheet> {
  ModalRoute? _loaderRoute;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8.0),
        ListTile(
          leading: const BottomActionItemImage(
            iconAssetPath: "src/icon/paste.png",
          ),
          title: Text(
            texts.bottom_action_bar_paste_invoice,
            style: theme.bottomSheetTextStyle,
          ),
          onTap: () => _pasteFromClipboard(context),
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
              onTap: () => _sendToBTCAddress(context, snapshot.balance),
            );
          },
        ),
        const SizedBox(height: 8.0)
      ],
    );
  }

  // TODO: Improve error handling flow to reduce open Enter Payment Info Dialog calls
  Future<void> _pasteFromClipboard(BuildContext context) async {
    try {
      final inputBloc = context.read<InputBloc>();
      _setLoading(true);
      // Get clipboard data
      await Clipboard.getData("text/plain").then(
        (clipboardData) async {
          final clipboardText = clipboardData?.text;
          _log.v("Clipboard text: $clipboardText");
          // Close bottom sheet
          Navigator.of(context).pop();
          if (clipboardText != null) {
            // Parse clipboard text
            await inputBloc.parseInput(input: clipboardText).then(
              (parsedInput) {
                // Handle parsed input
                inputBloc.inputHandler.handleInputData(parsedInput).then(
                  (result) async {
                    _setLoading(false);
                    // If input data can't be handled(unsupported input type) display EnterPaymentInfoDialog
                    if (result == false) {
                      _showEnterPaymentInfoDialog(context);
                    } else {
                      inputBloc.inputHandler.handleResult(result);
                    }
                  },
                ).catchError((e) {
                  _setLoading(false);
                  // If there's error handling parsed input display EnterPaymentInfoDialog
                  _showEnterPaymentInfoDialog(
                    context,
                  );
                });
              },
            );
          } else {
            _setLoading(false);
            // If clipboard data is empty, display EnterPaymentInfoDialog
            _showEnterPaymentInfoDialog(
              context,
            );
          }
        },
      );
    } catch (e) {
      _setLoading(false);
      // If there's an error getting the clipboard data, display EnterPaymentInfoDialog
      _showEnterPaymentInfoDialog(
        context,
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _showEnterPaymentInfoDialog(
    BuildContext context,
  ) async {
    await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => EnterPaymentInfoDialog(),
    );
  }

  void _sendToBTCAddress(BuildContext context, int maxValue) {
    final navigator = Navigator.of(context);
    // Close bottom sheet
    navigator.pop();
    // and open Send to BTC Address page
    navigator.pushNamed(
      "/withdraw_funds",
      arguments: WithdrawFundsPolicy(
        WithdrawKind.withdraw_funds,
        0,
        maxValue,
      ),
    );
  }

  void _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(context);
      Navigator.of(context).push(_loaderRoute!);
      return;
    }

    if (!visible && (_loaderRoute != null && _loaderRoute!.isActive)) {
      _loaderRoute!.navigator?.removeRoute(_loaderRoute!);
      _loaderRoute = null;
    }
  }
}

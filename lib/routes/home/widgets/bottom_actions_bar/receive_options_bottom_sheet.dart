import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_action_item_image.dart';

class ReceiveOptionsBottomSheet extends StatelessWidget {
  final AccountState account;
  final GlobalKey firstPaymentItemKey;

  const ReceiveOptionsBottomSheet({
    super.key,
    required this.firstPaymentItemKey,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8.0),
            ListTile(
              leading: const BottomActionItemImage(
                iconAssetPath: "src/icon/paste.png",
              ),
              title: Text(
                texts.bottom_action_bar_receive_invoice,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(context, "/create_invoice"),
            ),
            Divider(
              height: 0.0,
              color: Colors.white.withOpacity(0.2),
              indent: 72.0,
            ),
            ListTile(
              leading: const BottomActionItemImage(
                iconAssetPath: "src/icon/bitcoin.png",
              ),
              title: Text(
                texts.bottom_action_bar_receive_btc_address,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(context, "/swap_page"),
            ),
            Divider(
              height: 0.0,
              color: Colors.white.withOpacity(0.2),
              indent: 72.0,
            ),
            ListTile(
              leading: const BottomActionItemImage(
                iconAssetPath: "src/icon/credit_card.png",
              ),
              title: Text(
                texts.bottom_action_bar_buy_bitcoin,
                style: theme.bottomSheetTextStyle,
              ),
              onTap: () => _push(context, "/buy_bitcoin"),
            ),
            account.maxChanReserve == 0
                ? const SizedBox(height: 8.0)
                : WarningBox(
                    boxPadding: const EdgeInsets.all(16),
                    contentPadding: const EdgeInsets.all(8),
                    child: AutoSizeText(
                      texts.bottom_action_bar_warning_balance_title(
                        currencyState.bitcoinCurrency.format(
                          account.maxChanReserve,
                          removeTrailingZeros: true,
                        ),
                      ),
                      maxFontSize: themeData.textTheme.titleMedium!.fontSize!,
                      style: themeData.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        );
      },
    );
  }

  void _push(BuildContext context, String route) {
    final navigatorState = Navigator.of(context);
    navigatorState.pop();
    navigatorState.pushNamed(route);
  }
}

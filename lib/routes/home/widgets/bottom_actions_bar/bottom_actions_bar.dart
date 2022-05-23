import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bottom_action_item.dart';
import 'bottom_action_item_image.dart';
import 'enter_payment_info_dialog.dart';

class BottomActionsBar extends StatelessWidget {
  final AccountState account;
  final GlobalKey firstPaymentItemKey;

  const BottomActionsBar(
    this.account,
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final actionsGroup = AutoSizeGroup();

    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BottomActionItem(
              onPress: () => _showSendOptions(context),
              group: actionsGroup,
              text: texts.bottom_action_bar_send,
              iconAssetPath: "src/icon/send-action.png",
            ),
            Container(
              width: 64,
            ),
            BottomActionItem(
              onPress: () => _showReceiveOptions(context, account),
              group: actionsGroup,
              text: texts.bottom_action_bar_receive,
              iconAssetPath: "src/icon/receive-action.png",
            ),
          ],
        ),
      ),
    );
  }

  Future _showSendOptions(BuildContext context) async {
    final texts = AppLocalizations.of(context)!;
    final invoiceBloc = context.read<InvoiceBloc>();

    await showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return StreamBuilder<DecodedClipboardData>(
          stream: invoiceBloc.decodedClipboardStream,
          builder: (context, snapshot) {
            final connected = account.status == AccountStatus.CONNECTED;
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
                    context,
                    invoiceBloc,
                    snapshot.data,
                  ),
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
      },
    );
  }

  Future _showReceiveOptions(
    BuildContext context,
    AccountState account,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, currencyState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8.0),
                ListTile(
                  enabled: true,
                  leading: const BottomActionItemImage(
                    iconAssetPath: "src/icon/paste.png",
                    enabled: true,
                  ),
                  title: Text(
                    texts.bottom_action_bar_receive_invoice,
                    style: theme.bottomSheetTextStyle,
                  ),
                  onTap: () => _push(context, "/create_invoice"),
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
                          maxFontSize: themeData.textTheme.subtitle1!.fontSize!,
                          style: themeData.textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
              ],
            );
          },
        );
      },
    );
  }

  void _pasteTapped(
    BuildContext context,
    InvoiceBloc invoiceBloc,
    DecodedClipboardData? clipboardData,
  ) async {
    Navigator.of(context).pop();
    if (clipboardData != null) {
      final data = clipboardData.data;
      if (clipboardData.type == ClipboardDataType.paymentRequest) {
        invoiceBloc.addIncomingInvoice(data ?? "");
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
          invoiceBloc,
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

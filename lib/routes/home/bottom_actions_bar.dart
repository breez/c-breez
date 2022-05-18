import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/enter_payment_info_dialog.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomActionsBar extends StatelessWidget {
  final AccountState account;
  final GlobalKey firstPaymentItemKey;

  const BottomActionsBar(this.account, this.firstPaymentItemKey);

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    AutoSizeGroup actionsGroup = AutoSizeGroup();

    return BottomAppBar(
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _Action(
              onPress: () => _showSendOptions(context),
              group: actionsGroup,
              text: texts.bottom_action_bar_send,
              iconAssetPath: "src/icon/send-action.png",
            ),
            Container(
              width: 64,
            ),
            _Action(
              onPress: () => showReceiveOptions(context, account),
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
    InvoiceBloc invoiceBloc = context.read<InvoiceBloc>();
    AccountBloc accBloc = context.read<AccountBloc>();

    await showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return StreamBuilder<DecodedClipboardData>(
              stream: invoiceBloc.decodedClipboardStream,
              builder: (context, snapshot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8.0),
                    ListTile(
                      enabled: account.status == AccountStatus.CONNECTED,
                      leading: _ActionImage(
                          iconAssetPath: "src/icon/paste.png",
                          enabled: account.status == AccountStatus.CONNECTED),
                      title: Text(
                        texts.bottom_action_bar_paste_invoice,
                        style: theme.bottomSheetTextStyle,
                      ),
                      onTap: () async {
                        Navigator.of(context).pop();
                        DecodedClipboardData? clipboardData = snapshot.data;
                        if (clipboardData != null) {
                          if (clipboardData.type ==
                              ClipboardDataType.payamentRequest) {
                            invoiceBloc.addIncomingInvoice(clipboardData.data!);
                          } else if (clipboardData.type ==
                              ClipboardDataType.nodeID) {
                            Navigator.of(context).push(FadeInRoute(
                              builder: (_) => SpontaneousPaymentPage(
                                  clipboardData.data!, firstPaymentItemKey),
                            ));
                          }
                        } else {
                          return showDialog(
                              useRootNavigator: false,
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => EnterPaymentInfoDialog(
                                  context, invoiceBloc, firstPaymentItemKey));
                        }
                      },
                    ),
                    Divider(
                      height: 0.0,
                      color: Colors.white.withOpacity(0.2),
                      indent: 72.0,
                    ),
                    ListTile(
                        enabled: account.status == AccountStatus.CONNECTED,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/connect_to_pay.png",
                            enabled: account.status == AccountStatus.CONNECTED),
                        title: Text(
                          texts.bottom_action_bar_connect_to_pay,
                          style: theme.bottomSheetTextStyle,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/connect_to_pay");
                        }),
                    Divider(
                      height: 0.0,
                      color: Colors.white.withOpacity(0.2),
                      indent: 72.0,
                    ),
                    ListTile(
                        enabled: account.status == AccountStatus.CONNECTED,
                        leading: _ActionImage(
                            iconAssetPath: "src/icon/bitcoin.png",
                            enabled: account.status == AccountStatus.CONNECTED),
                        title: Text(
                          texts.bottom_action_bar_send_btc_address,
                          style: theme.bottomSheetTextStyle,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("/withdraw_funds");
                        }),
                    const SizedBox(height: 8.0)
                  ],
                );
              });
        });
  }
}

class _Action extends StatelessWidget {
  final String text;
  final AutoSizeGroup group;
  final String iconAssetPath;
  final Function() onPress;
  final Alignment minimizedAlignment;

  const _Action({
    Key? key,
    required this.text,
    required this.group,
    required this.iconAssetPath,
    required this.onPress,
    this.minimizedAlignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: onPress,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.bottomAppBarBtnStyle.copyWith(
              fontSize: 13.5 / MediaQuery.of(context).textScaleFactor),
          maxLines: 1,
        ),
      ),
    );
  }
}

class _ActionImage extends StatelessWidget {
  final String iconAssetPath;
  final bool enabled;

  const _ActionImage(
      {Key? key, required this.iconAssetPath, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(iconAssetPath),
      color: enabled ? Colors.white : Theme.of(context).disabledColor,
      fit: BoxFit.contain,
      width: 24.0,
      height: 24.0,
    );
  }
}

Future showReceiveOptions(BuildContext parentContext, AccountState account) {
  final texts = AppLocalizations.of(parentContext)!;

  return showModalBottomSheet(
    context: parentContext,
    builder: (ctx) {
      return BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, currencyState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8.0),
              ListTile(
                  enabled: true,
                  leading: const _ActionImage(
                    iconAssetPath: "src/icon/paste.png",
                    enabled: true,
                  ),
                  title: Text(
                    texts.bottom_action_bar_receive_invoice,
                    style: theme.bottomSheetTextStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/create_invoice");
                  }),
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
                        maxFontSize:
                            Theme.of(context).textTheme.subtitle1!.fontSize!,
                          style: Theme.of(context).textTheme.headline6,
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

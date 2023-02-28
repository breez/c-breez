import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/receive_options_bottom_sheet.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/send_options_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_action_item.dart';

class BottomActionsBar extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;

  const BottomActionsBar(
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actionsGroup = AutoSizeGroup();

    return BlocBuilder<AccountBloc, AccountState>(builder: (context, account) {
      return BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SendOptions(
                firstPaymentItemKey: firstPaymentItemKey,
                actionsGroup: actionsGroup,
              ),
              Container(width: 64),
              ReceiveOptions(
                account: account,
                firstPaymentItemKey: firstPaymentItemKey,
                actionsGroup: actionsGroup,
              )
            ],
          ),
        ),
      );
    });
  }
}

class SendOptions extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> firstPaymentItemKey;
  final AutoSizeGroup actionsGroup;

  const SendOptions({
    Key? key,
    required this.firstPaymentItemKey,
    required this.actionsGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BottomActionItem(
      onPress: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return SendOptionsBottomSheet(
            firstPaymentItemKey: firstPaymentItemKey,
          );
        },
      ),
      group: actionsGroup,
      text: texts.bottom_action_bar_send,
      iconAssetPath: "src/icon/send-action.png",
    );
  }
}

class ReceiveOptions extends StatelessWidget {
  final AccountState account;
  final GlobalKey<State<StatefulWidget>> firstPaymentItemKey;
  final AutoSizeGroup actionsGroup;

  const ReceiveOptions({
    Key? key,
    required this.account,
    required this.firstPaymentItemKey,
    required this.actionsGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return BottomActionItem(
      onPress: () => showModalBottomSheet(
        context: context,
        builder: (context) {
          return ReceiveOptionsBottomSheet(
            account: account,
            firstPaymentItemKey: firstPaymentItemKey,
          );
        },
      ),
      group: actionsGroup,
      text: texts.bottom_action_bar_receive,
      iconAssetPath: "src/icon/receive-action.png",
    );
  }
}

import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/home/widgets/app_bar/warning_action.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_address_page.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountRequiredActionsIndicator extends StatelessWidget {
  const AccountRequiredActionsIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accState) {
        return _build(
          context,
          accState,
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    AccountState accountModel,
  ) {
    final navigatorState = Navigator.of(context);

    List<Widget> warnings = [];
    int walletBalance = accountModel.walletBalance;

    if (walletBalance > 0) {
      warnings.add(
        WarningAction(
          () => navigatorState.push(
            FadeInRoute(
              builder: (_) => WithdrawFundsAddressPage(
                walletBalance,
              ),
            ),
          ),
        ),
      );
    }

    LspInformation? lsp = context.read<LSPBloc>().state;
    if (lsp == null) {
      warnings.add(WarningAction(() {
        navigatorState.pushNamed("/select_lsp");
      }));
    }

    if (warnings.isEmpty) {
      return const SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: warnings,
    );
  }
}

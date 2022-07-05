import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_confirm_button.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_speed_chooser.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_speed_message.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_summary.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsConfirmationPage extends StatefulWidget {
  final String address;

  const WithdrawFundsConfirmationPage(
    this.address, {
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawFundsConfirmationPage> createState() =>
      _WithdrawFundsConfirmationPageState();
}

class _WithdrawFundsConfirmationPageState
    extends State<WithdrawFundsConfirmationPage> {
  @override
  void initState() {
    super.initState();
    context.read<WithdrawFudsBloc>().fetchTransactionConst();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          texts.sweep_all_coins_speed,
        ),
      ),
      body: BlocBuilder<WithdrawFudsBloc, WithdrawFudsState>(
        builder: (context, transaction) {
          if (transaction is WithdrawFudsInfoState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsConfirmationSpeedChooser(transaction),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsSpeedMessage(context, transaction),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsSummary(),
                ),
                Expanded(child: Container()),
                const Center(
                  child: WithdrawFundsConfirmationConfirmButton(),
                ),
              ],
            );
          } else {
            return const Center(
              child: Loader(),
            );
          }
        },
      ),
    );
  }
}

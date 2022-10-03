import 'package:breez_sdk/sdk.dart';
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
import 'package:fixnum/fixnum.dart';

class WithdrawFundsConfirmationPage extends StatefulWidget {
  final String address;
  final Int64 amount;

  const WithdrawFundsConfirmationPage(
    this.address,
    this.amount, {
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawFundsConfirmationPage> createState() => _WithdrawFundsConfirmationPageState();
}

class _WithdrawFundsConfirmationPageState extends State<WithdrawFundsConfirmationPage> {
  var _speed = TransactionCostSpeed.regular;

  @override
  void initState() {
    super.initState();
    context.read<WithdrawFundsBloc>().fetchTransactionConst();
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
      body: BlocBuilder<WithdrawFundsBloc, WithdrawFudsState>(
        builder: (context, transaction) {
          if (transaction is WithdrawFudsInfoState) {
            final selected = _speed == TransactionCostSpeed.regular
                ? transaction.regular
                : _speed == TransactionCostSpeed.priority
                    ? transaction.priority
                    : transaction.economy;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsConfirmationSpeedChooser(
                    _speed,
                    (speed) {
                      if (mounted) {
                        setState(() {
                          _speed = speed;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsSpeedMessage(context, selected.waitingTime),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsSummary(
                    widget.amount,
                    selected.fee,
                    widget.amount - selected.fee,
                  ),
                ),
                Expanded(child: Container()),
                Center(
                  child: WithdrawFundsConfirmationConfirmButton(
                    widget.address,
                    _speed,
                  ),
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

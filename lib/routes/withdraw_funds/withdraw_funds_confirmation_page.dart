import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_confirm_button.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_speed_chooser.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_speed_message.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_summary.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WithdrawFundsConfirmationPage extends StatefulWidget {
  final String address;
  final int amount;

  const WithdrawFundsConfirmationPage(
    this.address,
    this.amount, {
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawFundsConfirmationPage> createState() => _WithdrawFundsConfirmationPageState();
}

class _WithdrawFundsConfirmationPageState extends State<WithdrawFundsConfirmationPage> {
  TransactionCost? _transactionCost;

  @override
  void initState() {
    super.initState();
    context.read<WithdrawFundsBloc>().fetchTransactionCost();
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
            final selectedCost = _transactionCost ?? transaction.regular;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsConfirmationSpeedChooser(
                    currentCost: selectedCost,
                    onCostChanged: (newCost) {
                      if (mounted) {
                        setState(() {
                          _transactionCost = newCost;
                        });
                      }
                    },
                    economy: transaction.economy,
                    regular: transaction.regular,
                    priority: transaction.priority,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsSpeedMessage(context, selectedCost.waitingTime),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: WithdrawFundsSummary(
                    widget.amount,
                    selectedCost.calculateFee(),
                    widget.amount - selectedCost.calculateFee(),
                  ),
                ),
                Expanded(child: Container()),
                Center(
                  child: WithdrawFundsConfirmationConfirmButton(
                    widget.address,
                    selectedCost.fee,
                  ),
                ),
              ],
            );
          } else if (transaction is WithdrawFudsErrorState) {
            return Column(
              children: [
                Expanded(child: Container()),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(transaction.message),
                  ),
                ),
                Expanded(child: Container()),
                TextButton(
                  onPressed: () => context.read<WithdrawFundsBloc>().fetchTransactionCost(),
                  child: Text(
                    texts.sweep_all_coins_action_retry,
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

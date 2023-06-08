import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_bloc.dart';
import 'package:c_breez/bloc/withdraw/withdraw_funds_state.dart';
import 'package:c_breez/routes/withdraw_funds/confirmation_page/widgets/sweep_button.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/fee_chooser/fee_chooser.dart';

class WithdrawFundsConfirmationPage extends StatefulWidget {
  final String toAddress;
  final int walletBalance;

  const WithdrawFundsConfirmationPage({
    Key? key,
    required this.toAddress,
    required this.walletBalance,
  }) : super(key: key);

  @override
  State<WithdrawFundsConfirmationPage> createState() => _WithdrawFundsConfirmationPageState();
}

class _WithdrawFundsConfirmationPageState extends State<WithdrawFundsConfirmationPage> {
  List<FeeOption> affordableFees = [];
  late int selectedFeeIndex;

  late Future<List<FeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchFeeOptionsFuture = context.read<WithdrawFundsBloc>().fetchFeeOptions();
    _fetchFeeOptionsFuture.then((feeOptions) {
      setState(() {
        affordableFees = feeOptions.where((f) => f.isAffordable(widget.walletBalance)).toList();
        // Default to Regular processing speed if possible
        selectedFeeIndex = (affordableFees.length / 2).floor();
        /* INFO: We do not add variance when calculating fee, so there's no need for the following logic:
        // If for some reason(mempool can return same sat/vB for multiple fee rate presets)
        // the affordability does not match the speed preset order, select first affordable item
        int firstAffordableIndex =
            feeOptions.indexWhere((f) => f.isAffordable(widget.walletBalance));
        if (selectedFeeIndex < firstAffordableIndex) {
          selectedFeeIndex = firstAffordableIndex;
        }
         */
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(
        title: Text(texts.sweep_all_coins_speed),
      ),
      body: FutureBuilder(
        future: _fetchFeeOptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return _ErrorMessage(
              message: texts.reverse_swap_confirmation_error_fetch_fee,
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Loader());
          }

          if (affordableFees.isNotEmpty) {
            return FeeChooser(
              walletBalance: widget.walletBalance,
              feeOptions: snapshot.data!,
              selectedFeeIndex: selectedFeeIndex,
              onSelect: (index) => setState(() {
                selectedFeeIndex = index;
              }),
            );
          } else {
            return _ErrorMessage(
              message: texts.reverse_swap_confirmation_error_funds_fee,
            );
          }
        },
      ),
      bottomNavigationBar: (affordableFees.isNotEmpty)
          ? SweepButton(
              toAddress: widget.toAddress,
              feeRateSatsPerVbyte: 1,
            )
          : null,
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

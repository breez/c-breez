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
  final int amount;

  const WithdrawFundsConfirmationPage({
    Key? key,
    required this.toAddress,
    required this.amount,
  }) : super(key: key);

  @override
  State<WithdrawFundsConfirmationPage> createState() => _WithdrawFundsConfirmationPageState();
}

class _WithdrawFundsConfirmationPageState extends State<WithdrawFundsConfirmationPage> {
  List<FeeOption> affordableFees = [];
  int selectedFeeIndex = -1;

  late Future<List<FeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchFeeOptionsFuture = context.read<WithdrawFundsBloc>().fetchFeeOptions();
    _fetchFeeOptionsFuture.then((feeOptions) {
      setState(() {
        affordableFees = feeOptions.where((f) => f.isAffordable(widget.amount)).toList();
        selectedFeeIndex = (affordableFees.length / 2).floor();
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
              walletBalance: widget.amount,
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
      bottomNavigationBar:
          (affordableFees.isNotEmpty && selectedFeeIndex > 0 && selectedFeeIndex < affordableFees.length)
              ? SweepButton(
                  toAddress: widget.toAddress,
                  feeRateSatsPerVbyte: affordableFees[selectedFeeIndex].fee,
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

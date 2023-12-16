import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/bloc/fee_options/fee_options_bloc.dart';
import 'package:c_breez/routes/withdraw/redeem_onchain_funds/confirmation_page/widgets/redeem_onchain_funds_button.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/fee_chooser.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedeemOnchainConfirmationPage extends StatefulWidget {
  final String toAddress;
  final int amountSat;

  const RedeemOnchainConfirmationPage({
    super.key,
    required this.toAddress,
    required this.amountSat,
  });

  @override
  State<RedeemOnchainConfirmationPage> createState() => _RedeemOnchainConfirmationPageState();
}

class _RedeemOnchainConfirmationPageState extends State<RedeemOnchainConfirmationPage> {
  List<FeeOption> affordableFees = [];
  int selectedFeeIndex = -1;

  late Future<List<FeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchFeeOptionsFuture = context.read<FeeOptionsBloc>().fetchFeeOptions(
          toAddress: widget.toAddress,
        );
    _fetchFeeOptionsFuture.then((feeOptions) {
      setState(() {
        affordableFees = feeOptions.where((f) => f.isAffordable(widget.amountSat)).toList();
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
              message: texts.sweep_all_coins_error_retrieve_fees,
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: Loader(
                color: Colors.white,
              ),
            );
          }

          if (affordableFees.isNotEmpty) {
            return FeeChooser(
              walletBalance: widget.amountSat,
              feeOptions: snapshot.data!,
              selectedFeeIndex: selectedFeeIndex,
              onSelect: (index) => setState(() {
                selectedFeeIndex = index;
              }),
            );
          } else {
            return _ErrorMessage(
              message: texts.sweep_all_coins_error_amount_small,
            );
          }
        },
      ),
      bottomNavigationBar:
          (affordableFees.isNotEmpty && selectedFeeIndex >= 0 && selectedFeeIndex < affordableFees.length)
              ? RedeemOnchainFundsButton(
                  toAddress: widget.toAddress,
                  satPerVbyte: affordableFees[selectedFeeIndex].feeVByte,
                )
              : null,
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({
    required this.message,
  });

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

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/redeem_onchain_funds/redeem_onchain_funds_bloc.dart';
import 'package:c_breez/models/models.dart';
import 'package:c_breez/routes/withdraw/redeem_onchain_funds/confirmation_page/widgets/redeem_onchain_funds_button.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/fee_chooser.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RedeemOnchainConfirmationPage extends StatefulWidget {
  final String toAddress;
  final int amountSat;

  const RedeemOnchainConfirmationPage({super.key, required this.toAddress, required this.amountSat});

  @override
  State<RedeemOnchainConfirmationPage> createState() => _RedeemOnchainConfirmationPageState();
}

class _RedeemOnchainConfirmationPageState extends State<RedeemOnchainConfirmationPage> {
  List<RedeemOnchainFeeOption> affordableFees = [];
  int selectedFeeIndex = -1;

  late Future<List<RedeemOnchainFeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchRedeemOnchainFeeOptions();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      appBar: AppBar(title: Text(texts.sweep_all_coins_speed)),
      body: FutureBuilder(
        future: _fetchFeeOptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            return _ErrorMessage(message: texts.sweep_all_coins_error_retrieve_fees);
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Loader(color: Colors.white));
          }

          if (affordableFees.isNotEmpty) {
            return FeeChooser(
              amountSat: widget.amountSat,
              feeOptions: snapshot.data!,
              selectedFeeIndex: selectedFeeIndex,
              onSelect: (index) => setState(() {
                selectedFeeIndex = index;
              }),
            );
          } else {
            return _ErrorMessage(message: texts.sweep_all_coins_error_amount_small);
          }
        },
      ),
      bottomNavigationBar:
          (affordableFees.isNotEmpty && selectedFeeIndex >= 0 && selectedFeeIndex < affordableFees.length)
          ? RedeemOnchainFundsButton(
              toAddress: widget.toAddress,
              satPerVbyte: affordableFees[selectedFeeIndex].satPerVbyte,
            )
          : null,
    );
  }

  void _fetchRedeemOnchainFeeOptions() {
    final redeemOnchainFundsBloc = context.read<RedeemOnchainFundsBloc>();
    _fetchFeeOptionsFuture = redeemOnchainFundsBloc.fetchRedeemOnchainFeeOptions(toAddress: widget.toAddress);
    _fetchFeeOptionsFuture.then((feeOptions) {
      if (mounted) {
        final account = context.read<AccountBloc>().state;
        setState(() {
          affordableFees = feeOptions
              .where(
                (f) =>
                    f.isAffordable(walletBalanceSat: account.walletBalanceSat, amountSat: widget.amountSat),
              )
              .toList();
          selectedFeeIndex = (affordableFees.length / 2).floor();
        });
      }
    });
  }
}

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

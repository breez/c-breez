import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/bloc/fee_options/fee_options_bloc.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/confirmation_page/widgets/reverse_swap_button.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/fee_chooser.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReverseSwapConfirmationPage extends StatefulWidget {
  final int amountSat;
  final String onchainRecipientAddress;
  final String feesHash;
  final int? boltzFees;

  const ReverseSwapConfirmationPage({
    super.key,
    required this.amountSat,
    required this.onchainRecipientAddress,
    required this.feesHash,
    this.boltzFees,
  });

  @override
  State<ReverseSwapConfirmationPage> createState() => _ReverseSwapConfirmationPageState();
}

class _ReverseSwapConfirmationPageState extends State<ReverseSwapConfirmationPage> {
  List<FeeOption> affordableFees = [];
  int selectedFeeIndex = -1;

  late Future<List<FeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchFeeOptionsFuture = context.read<FeeOptionsBloc>().fetchFeeOptions(
          toAddress: widget.onchainRecipientAddress,
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
              message: texts.reverse_swap_confirmation_error_fetch_fee,
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Loader());
          }

          if (affordableFees.isNotEmpty) {
            return FeeChooser(
              walletBalance: widget.amountSat,
              feeOptions: snapshot.data!,
              selectedFeeIndex: selectedFeeIndex,
              boltzFees: widget.boltzFees,
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
          (affordableFees.isNotEmpty && selectedFeeIndex >= 0 && selectedFeeIndex < affordableFees.length)
              ? SafeArea(
                  child: ReverseSwapButton(
                    amountSat: widget.amountSat,
                    onchainRecipientAddress: widget.onchainRecipientAddress,
                    satPerVbyte: affordableFees[selectedFeeIndex].feeVByte,
                    feesHash: widget.feesHash,
                  ),
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

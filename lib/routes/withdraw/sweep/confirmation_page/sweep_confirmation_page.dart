import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/fee_options/fee_options_bloc.dart';
import 'package:c_breez/bloc/fee_options/fee_option.dart';
import 'package:c_breez/routes/withdraw/sweep/confirmation_page/widgets/sweep_button.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/fee_chooser.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SweepConfirmationPage extends StatefulWidget {
  final String toAddress;
  final int amountSat;

  const SweepConfirmationPage({
    Key? key,
    required this.toAddress,
    required this.amountSat,
  }) : super(key: key);

  @override
  State<SweepConfirmationPage> createState() => _SweepConfirmationPageState();
}

class _SweepConfirmationPageState extends State<SweepConfirmationPage> {
  List<FeeOption> affordableFees = [];
  int selectedFeeIndex = -1;

  late Future<List<FeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchFeeOptionsFuture = context.read<FeeOptionsBloc>().fetchFeeOptions();
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
            return const Center(child: Loader());
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
              ? SweepButton(
                  toAddress: widget.toAddress,
                  feeRateSatsPerVbyte: affordableFees[selectedFeeIndex].feeVByte,
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

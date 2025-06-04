import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/models/models.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/confirmation_page/widgets/reverse_swap_button.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/fee_chooser.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReverseSwapConfirmationPage extends StatefulWidget {
  final int amountSat;
  final SwapAmountType amountType;
  final String onchainRecipientAddress;
  final bool isMaxValue;

  const ReverseSwapConfirmationPage({
    super.key,
    required this.amountSat,
    required this.amountType,
    required this.onchainRecipientAddress,
    required this.isMaxValue,
  });

  @override
  State<ReverseSwapConfirmationPage> createState() => _ReverseSwapConfirmationPageState();
}

class _ReverseSwapConfirmationPageState extends State<ReverseSwapConfirmationPage> {
  List<ReverseSwapFeeOption> affordableFees = <ReverseSwapFeeOption>[];
  int selectedFeeIndex = -1;

  late Future<List<ReverseSwapFeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchReverseSwapFeeOptions();
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
            return _ErrorMessage(message: texts.reverse_swap_confirmation_error_fetch_fee);
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Loader());
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
            return _ErrorMessage(message: texts.reverse_swap_confirmation_error_funds_fee);
          }
        },
      ),
      bottomNavigationBar:
          (affordableFees.isNotEmpty && selectedFeeIndex >= 0 && selectedFeeIndex < affordableFees.length)
          ? SafeArea(
              child: ReverseSwapButton(
                recipientAddress: widget.onchainRecipientAddress,
                prepareOnchainPaymentResponse: affordableFees[selectedFeeIndex].pairInfo,
              ),
            )
          : null,
    );
  }

  void _fetchReverseSwapFeeOptions() {
    final reverseSwapBloc = context.read<ReverseSwapBloc>();
    _fetchFeeOptionsFuture = reverseSwapBloc.fetchReverseSwapFeeOptions(
      amountSat: widget.amountSat,
      amountType: widget.isMaxValue ? SwapAmountType.Send : SwapAmountType.Receive,
    );
    _fetchFeeOptionsFuture.then((feeOptions) {
      if (mounted) {
        final account = context.read<AccountBloc>().state;
        setState(() {
          affordableFees = feeOptions
              .where((f) => f.isAffordable(balanceSat: account.balanceSat, amountSat: widget.amountSat))
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

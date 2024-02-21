import 'dart:async';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/models/fee_options/fee_option.dart';
import 'package:c_breez/routes/get-refund/widgets/refund_button.dart';
import 'package:c_breez/routes/withdraw/widgets/fee_chooser/fee_chooser.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RefundConfirmationPage extends StatefulWidget {
  final int amountSat;
  final String swapAddress;
  final String toAddress;
  final String? originalTransaction;

  const RefundConfirmationPage({
    required this.amountSat,
    required this.toAddress,
    required this.swapAddress,
    this.originalTransaction,
  });

  @override
  State<StatefulWidget> createState() {
    return RefundConfirmationState();
  }
}

class RefundConfirmationState extends State<RefundConfirmationPage> {
  List<RefundFeeOption> affordableFees = [];
  int selectedFeeIndex = -1;

  late Future<List<RefundFeeOption>> _fetchFeeOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchRefundFeeOptions();
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
              amountSat: widget.amountSat,
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
              ? RefundButton(
                  req: RefundRequest(
                    satPerVbyte: affordableFees[selectedFeeIndex].satPerVbyte,
                    toAddress: widget.toAddress,
                    swapAddress: widget.swapAddress,
                  ),
                )
              : SingleButtonBottomBar(
                  text: texts.sweep_all_coins_action_retry,
                  onPressed: () => _fetchRefundFeeOptions,
                  stickToBottom: true,
                ),
    );
  }

  void _fetchRefundFeeOptions() {
    final refundBloc = context.read<RefundBloc>();
    _fetchFeeOptionsFuture = refundBloc.fetchRefundFeeOptions(
      toAddress: widget.toAddress,
      swapAddress: widget.swapAddress,
    );
    _fetchFeeOptionsFuture.then((feeOptions) {
      setState(() {
        final account = context.read<AccountBloc>().state;
        affordableFees = feeOptions
            .where((f) => f.isAffordable(balance: account.balance, amountSat: widget.amountSat))
            .toList();
        selectedFeeIndex = (affordableFees.length / 2).floor();
      });
    });
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

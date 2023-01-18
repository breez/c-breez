import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/routes/subswap/swap/get_refund/widgets/send_onchain_form.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class SendOnchain extends StatefulWidget {
  final int amount;
  final Future<String?> Function(String address, int fee) onBroadcast;
  final String? originalTransaction;

  const SendOnchain({
    required this.amount,
    required this.onBroadcast,
    this.originalTransaction,
  });

  @override
  State<StatefulWidget> createState() {
    return SendOnchainState();
  }
}

class SendOnchainState extends State<SendOnchain> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _feeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final query = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(texts.get_refund_transaction)),
      body: SingleChildScrollView(
        child: SizedBox(
          height: query.size.height - kToolbarHeight - query.padding.top,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SendOnchainForm(
                amount: widget.amount,
                formKey: _formKey,
                addressController: _addressController,
                feeController: _feeController,
                originalTransaction: widget.originalTransaction,
              ),
              SingleButtonBottomBar(
                text: texts.send_on_chain_broadcast,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onBroadcast(_addressController.text, _getFee()).then((txId) {
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getFee() {
    final raw = _feeController.text;
    if (raw.isEmpty) {
      return 0;
    }
    return int.tryParse(raw) ?? 0;
  }
}

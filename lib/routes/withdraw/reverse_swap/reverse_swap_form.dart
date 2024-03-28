import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/withdraw/model/withdraw_funds_model.dart';
import 'package:c_breez/routes/withdraw/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/routes/withdraw/widgets/withdraw_funds_amount_text_form_field.dart';
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/amount_form_field/sat_amount_form_field_formatter.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _log = Logger("ReverseSwapForm");

class ReverseSwapForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final TextEditingController addressController;
  final bool withdrawMaxValue;
  final ValueChanged<bool> onChanged;
  final BitcoinAddressData? btcAddressData;
  final BitcoinCurrency bitcoinCurrency;
  final OnchainPaymentLimitsResponse paymentLimits;

  const ReverseSwapForm({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.addressController,
    required this.onChanged,
    required this.withdrawMaxValue,
    this.btcAddressData,
    required this.bitcoinCurrency,
    required this.paymentLimits,
  });

  @override
  State<ReverseSwapForm> createState() => _ReverseSwapFormState();
}

class _ReverseSwapFormState extends State<ReverseSwapForm> {
  final _validatorHolder = ValidatorHolder();

  @override
  void initState() {
    super.initState();
    if (widget.btcAddressData != null) {
      _fillBtcAddressData(widget.btcAddressData!);
    }
  }

  void _fillBtcAddressData(BitcoinAddressData addressData) {
    _log.info("Filling BTC Address data for ${addressData.address}");
    widget.addressController.text = addressData.address;
    if (addressData.amountSat != null) {
      _setAmount(addressData.amountSat!);
    }
  }

  void _setAmount(int amountSats) {
    setState(() {
      widget.amountController.text = widget.bitcoinCurrency
          .format(amountSats, includeDisplayName: false, userInput: true)
          .formatBySatAmountFormFieldFormatter();
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            BitcoinAddressTextFormField(
              context: context,
              controller: widget.addressController,
              validatorHolder: _validatorHolder,
            ),
            WithdrawFundsAmountTextFormField(
              context: context,
              bitcoinCurrency: widget.bitcoinCurrency,
              controller: widget.amountController,
              withdrawMaxValue: widget.withdrawMaxValue,
              balance: widget.paymentLimits.maxSat,
              policy: WithdrawFundsPolicy(
                WithdrawKind.withdraw_funds,
                widget.paymentLimits.minSat,
                widget.paymentLimits.maxSat,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                texts.withdraw_funds_use_all_funds,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
              ),
              trailing: Switch(
                value: widget.withdrawMaxValue,
                activeColor: Colors.white,
                onChanged: (bool value) async {
                  setState(() {
                    widget.onChanged(value);
                    if (widget.withdrawMaxValue) {
                      _setAmount(widget.paymentLimits.maxSat);
                    } else {
                      widget.amountController.text = "";
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

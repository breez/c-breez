import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/routes/spontaneous_payment/widgets/collapsible_list_item.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = Logger("SendOnchainForm");

class SendOnchainForm extends StatefulWidget {
  final int amount;
  final GlobalKey formKey;
  final TextEditingController addressController;
  final TextEditingController feeController;
  final String? originalTransaction;

  const SendOnchainForm({
    required this.amount,
    required this.formKey,
    required this.addressController,
    required this.feeController,
    this.originalTransaction,
  });

  @override
  SendOnchainFormState createState() => SendOnchainFormState();
}

class SendOnchainFormState extends State<SendOnchainForm> {
  final feeFocusNode = FocusNode();
  late KeyboardDoneAction _doneAction;
  bool feeUpdated = false;
  ValidatorHolder validatorHolder = ValidatorHolder();

  @override
  void initState() {
    super.initState();
    _doneAction = KeyboardDoneAction(focusNodes: [feeFocusNode]);
  }

  @override
  void didChangeDependencies() {
    _updateFee();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SendOnchainForm oldWidget) {
    _updateFee();
    super.didUpdateWidget(oldWidget);
  }

  void _updateFee() {
    final account = context.read<AccountBloc>().state;
    if (!feeUpdated && widget.feeController.text.isEmpty) {
      final feeRate = account.onChainFeeRate;
      widget.feeController.text = feeRate > 0 ? feeRate.toString() : "";
      feeUpdated = true;
    }
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CurrencyState currencyState = context.read<CurrencyBloc>().state;

    final texts = context.texts();
    final themeData = Theme.of(context);

    return Form(
      key: widget.formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.addressController,
              decoration: InputDecoration(
                labelText: texts.send_on_chain_btc_address,
                suffixIcon: IconButton(
                  padding: const EdgeInsets.only(top: 21.0),
                  alignment: Alignment.bottomRight,
                  icon: Image(
                    image: const AssetImage("src/icon/qr_scan.png"),
                    color: themeData.iconTheme.color,
                    fit: BoxFit.contain,
                    width: 24.0,
                    height: 24.0,
                  ),
                  tooltip: texts.send_on_chain_scan_barcode,
                  onPressed: () => _scanBarcode(),
                ),
              ),
              style: theme.FieldTextStyle.textStyle,
              onChanged: (address) async {
                await validatorHolder.lock.synchronized(
                  () async {
                    validatorHolder.valid = await context.read<AccountBloc>().isValidBitcoinAddress(address);
                  },
                );
              },
              validator: (address) {
                _log.info('validator called for $address, lock status: ${validatorHolder.lock.locked}');
                if (validatorHolder.valid) {
                  return null;
                } else {
                  return context.texts().send_on_chain_invalid_btc_address;
                }
              },
            ),
            TextFormField(
              focusNode: feeFocusNode,
              controller: widget.feeController,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: texts.send_on_chain_sat_per_byte_fee_rate,
              ),
              style: theme.FieldTextStyle.textStyle,
              validator: (value) {
                final feeText = widget.feeController.text;
                if (feeText.isEmpty) {
                  return texts.send_on_chain_invalid_fee_rate;
                }
                final number = int.tryParse(feeText);
                if (number == null || number <= 0) {
                  return texts.send_on_chain_invalid_fee_rate;
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                "${texts.send_on_chain_amount} ${currencyState.bitcoinCurrency.format(widget.amount)}",
                style: theme.textStyle,
              ),
            ),
            if (widget.originalTransaction != null) ...[
              CollapsibleListItem(
                title: texts.send_on_chain_original_transaction,
                sharedValue: widget.originalTransaction,
                userStyle: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _scanBarcode() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pushNamed<String>(context, "/qr_scan").then((barcode) {
      if (barcode == null) return;
      if (barcode.isEmpty) {
        showFlushbar(
          context,
          message: context.texts().send_on_chain_qr_code_not_detected,
        );
        return;
      }
      setState(() {
        widget.addressController.text = barcode;
      });
    });
  }
}

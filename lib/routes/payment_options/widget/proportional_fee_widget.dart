import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _log = FimberLog("ProportionalFeeWidget");

class ProportionalFeeWidget extends StatefulWidget {
  const ProportionalFeeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProportionalFeeWidget> createState() => _ProportionalFeeWidgetState();
}

class _ProportionalFeeWidgetState extends State<ProportionalFeeWidget> {
  final _proportionalFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: real implementation
    _proportionalFeeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Form(
              child: TextFormField(
                // TODO: real implementation
                enabled: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                controller: _proportionalFeeController,
                decoration: InputDecoration(
                  labelText: texts.payment_options_proportional_fee_label,
                  border: const UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  if (value.isEmpty) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  try {
                    final newProportionalFee = double.parse(value);
                    if (newProportionalFee < 0.0) {
                      return texts.payment_options_proportional_fee_label;
                    }
                  } catch (e) {
                    return texts.payment_options_proportional_fee_label;
                  }
                  return null;
                },
                onChanged: (value) {
                  // TODO real implementation
                  _log.v("onChanged: $value");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

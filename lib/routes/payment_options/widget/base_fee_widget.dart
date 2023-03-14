import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _log = FimberLog("BaseFeeWidget");

class BaseFeeWidget extends StatefulWidget {
  const BaseFeeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BaseFeeWidget> createState() => _BaseFeeWidgetState();
}

class _BaseFeeWidgetState extends State<BaseFeeWidget> {
  final _baseFeeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // TODO: real implementation
    _baseFeeController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Form(
              child: TextFormField(
                // TODO: real implementation
                enabled: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _baseFeeController,
                decoration: InputDecoration(
                  labelText: texts.payment_options_base_fee_label,
                  border: const UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return texts.payment_options_base_fee_label;
                  }
                  if (value.isEmpty) {
                    return texts.payment_options_base_fee_label;
                  }
                  try {
                    final newBaseFee = int.parse(value);
                    if (newBaseFee < 0) {
                      return texts.payment_options_base_fee_label;
                    }
                  } catch (e) {
                    return texts.payment_options_base_fee_label;
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

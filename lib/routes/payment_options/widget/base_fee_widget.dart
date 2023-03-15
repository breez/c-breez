import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Form(
              child: BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
                builder: (context, state) {
                  if (!state.saveEnabled) {
                    final baseFee = state.baseFee.toString();
                    if (_baseFeeController.text != baseFee) {
                      _baseFeeController.text = baseFee;
                    }
                  }

                  return TextFormField(
                    enabled: state.overrideFeeEnabled,
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
                      _log.v("onChanged: $value");
                      int baseFee;
                      try {
                        baseFee = int.parse(value);
                      } catch (e) {
                        _log.w("Failed to parse $value as int", ex: e);
                        return;
                      }
                      context.read<PaymentOptionsBloc>().setBaseFee(baseFee);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

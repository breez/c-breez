import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/form_validator.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("ProportionalFeeWidget");

class ProportionalFeeWidget extends StatefulWidget {
  const ProportionalFeeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ProportionalFeeWidget> createState() => _ProportionalFeeWidgetState();
}

class _ProportionalFeeWidgetState extends State<ProportionalFeeWidget> {
  final _proportionalFeeController = TextEditingController();

  StreamSubscription<PaymentOptionsState>? _subscription;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializeListeners());
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
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
              child: BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
                builder: (context, state) {
                  return TextFormField(
                    enabled: state.overrideFeeEnabled,
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
                    validator: proportionalFeeValidator,
                    onChanged: (value) {
                      _log.info("onChanged: $value");
                      double proportionalFee;
                      try {
                        proportionalFee = double.parse(value);
                      } catch (_) {
                        _log.info("Failed to parse $value as double");
                        return;
                      }
                      context.read<PaymentOptionsBloc>().setProportionalFee(proportionalFee);
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

  void _initializeListeners() {
    final bloc = context.read<PaymentOptionsBloc>();
    _subscription = bloc.stream.startWith(bloc.state).distinct().listen((state) {
      if (!state.saveEnabled) {
        final proportionalFee = state.proportionalFee.toStringAsFixed(2);
        if (_proportionalFeeController.text != proportionalFee) {
          _log.info("Setting proportionalFee to $proportionalFee");
          setState(() {
            _proportionalFeeController.text = proportionalFee;
          });
        }
      }
    });
  }
}

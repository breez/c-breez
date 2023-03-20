import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/form_validator.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

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
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
            child: Form(
              child: BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
                builder: (context, state) {
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
                    validator: baseFeeValidator,
                    onChanged: (value) {
                      _log.v("onChanged: $value");
                      int baseFee;
                      try {
                        baseFee = int.parse(value);
                      } catch (_) {
                        _log.v("Failed to parse $value as int");
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

  void _initializeListeners() {
    final bloc = context.read<PaymentOptionsBloc>();
    _subscription = bloc.stream.startWith(bloc.state).distinct().listen((state) {
      if (!state.saveEnabled) {
        final baseFee = state.baseFee.toString();
        if (_baseFeeController.text != baseFee) {
          _log.v("Setting base fee to $baseFee");
          setState(() {
            _baseFeeController.text = baseFee;
          });
        }
      }
    });
  }
}

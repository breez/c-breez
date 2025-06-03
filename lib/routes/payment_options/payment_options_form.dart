import 'dart:async';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/form_validator.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

final _log = Logger("PaymentOptionsForm");

class PaymentOptionsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const PaymentOptionsForm({required this.formKey, super.key});

  @override
  State<PaymentOptionsForm> createState() => _PaymentOptionsFormState();
}

class _PaymentOptionsFormState extends State<PaymentOptionsForm> {
  final _exemptFeeController = TextEditingController();
  final _proportionalFeeController = TextEditingController();
  final _channelSetupFeeLimitController = TextEditingController();

  StreamSubscription<PaymentOptionsState>? _subscription;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _initializeListeners());
  }

  void _initializeListeners() {
    final paymentOptionsBloc = context.read<PaymentOptionsBloc>();
    _subscription = paymentOptionsBloc.stream.startWith(paymentOptionsBloc.state).listen((state) {
      setPaymentOptions(state);
    });
  }

  void setPaymentOptions(PaymentOptionsState state) {
    final exemptFeeSat = (state.exemptFeeMsat ~/ 1000).toString();
    final proportionalFee = state.proportionalFee.toStringAsFixed(2);
    final channelFeeLimitMsat = (state.channelFeeLimitMsat ~/ 1000).toString();

    setState(() {
      _exemptFeeController.text = exemptFeeSat;
      _proportionalFeeController.text = proportionalFee;
      _channelSetupFeeLimitController.text = channelFeeLimitMsat;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final paymentOptionsBloc = context.read<PaymentOptionsBloc>();
    final texts = context.texts();

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Form(
              key: widget.formKey,
              child: BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        controller: _exemptFeeController,
                        decoration: InputDecoration(
                          labelText: texts.payment_options_exemptfee_label,
                          border: const UnderlineInputBorder(),
                        ),
                        validator: exemptFeeValidator,
                        onChanged: (value) {
                          _log.info("onChanged: $value");
                          try {
                            int.parse(value);
                          } catch (_) {
                            _log.info("Failed to parse $value as int");
                            return;
                          }
                        },
                        onSaved: (value) async {
                          await paymentOptionsBloc.setExemptfeeMsat(int.parse(value!) * 1000);
                        },
                      ),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        controller: _proportionalFeeController,
                        decoration: InputDecoration(
                          labelText: texts.payment_options_proportional_fee_label,
                          border: const UnderlineInputBorder(),
                        ),
                        validator: proportionalFeeValidator,
                        onChanged: (value) {
                          _log.info("onChanged: $value");

                          try {
                            double.parse(value);
                          } catch (_) {
                            _log.info("Failed to parse $value as double");
                            return;
                          }
                        },
                        onSaved: (value) async {
                          await paymentOptionsBloc.setProportionalFee(double.parse(value!));
                        },
                      ),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        controller: _channelSetupFeeLimitController,
                        decoration: InputDecoration(
                          labelText: texts.payment_options_auto_setup_fee_label,
                          border: const UnderlineInputBorder(),
                        ),
                        validator: channelSetupFeeLimitValidator,
                        onChanged: (value) {
                          _log.info("onChanged: $value");
                          try {
                            int.parse(value);
                          } catch (_) {
                            _log.info("Failed to parse $value as int");
                            return;
                          }
                        },
                        onSaved: (value) async {
                          await paymentOptionsBloc.setChannelSetupFeeLimitMsat(int.parse(value!) * 1000);
                        },
                      ),
                    ],
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

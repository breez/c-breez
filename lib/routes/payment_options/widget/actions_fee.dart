import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/routes/payment_options/widget/save_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionsFee extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ActionsFee({required this.formKey, super.key});

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BlocBuilder<PaymentOptionsBloc, PaymentOptionsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                child: Text(texts.payment_options_fee_action_reset),
                onPressed: () async {
                  try {
                    await context.read<PaymentOptionsBloc>().setDefaultPaymentOptions();
                    formKey.currentState!.reset();
                    if (!context.mounted) return;
                    showFlushbar(context, message: "Reverted fee settings to default values.");
                  } catch (_) {
                    showFlushbar(context, message: "Failed to reset fee settings.");
                  }
                },
              ),
              const SizedBox(width: 12.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                child: Text(texts.payment_options_fee_action_save),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => SaveDialog(formKey: formKey),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/payment_options/payment_options_bloc.dart';
import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/routes/payment_options/widget/save_dialog.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = Logger("ActionsFee");

class ActionsFee extends StatelessWidget {
  const ActionsFee({
    super.key,
  });

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
                child: Text(
                  texts.payment_options_fee_action_reset,
                ),
                onPressed: () {
                  _log.info("onPressed: reset");
                  context.read<PaymentOptionsBloc>().resetFees();
                },
              ),
              const SizedBox(width: 12.0),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  texts.payment_options_fee_action_save,
                ),
                onPressed: () {
                  _log.info("onPressed: save");
                  if (state.overrideFeeEnabled) {
                    showDialog(
                      context: context,
                      builder: (context) => const SaveDialog(),
                    );
                  } else {
                    context.read<PaymentOptionsBloc>().saveFees();
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

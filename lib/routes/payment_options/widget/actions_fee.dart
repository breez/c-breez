import 'package:breez_translations/breez_translations_locales.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

final _log = FimberLog("ActionsFee");

class ActionsFee extends StatelessWidget {
  const ActionsFee({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

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
              // TODO real implementation
              _log.v("onPressed: reset");
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
              // TODO real implementation
              _log.v("onPressed: save");
            },
          ),
        ],
      ),
    );
  }
}

import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class WithdrawFundsAddressNextButton extends StatelessWidget {
  final TextEditingController addressController;
  final bool Function() validator;

  const WithdrawFundsAddressNextButton({
    Key? key,
    required this.addressController,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: SubmitButton(
        texts.withdraw_funds_action_next,
        () {
          if (validator()) {
            Navigator.of(context).pushNamed(
              "/withdraw_funds_confirmation",
              arguments: addressController.text,
            );
          }
        },
      ),
    );
  }
}

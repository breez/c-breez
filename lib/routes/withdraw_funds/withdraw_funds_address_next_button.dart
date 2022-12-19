import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/withdraw_funds/withdraw_funds_confirmation_page.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';

class WithdrawFundsAddressNextButton extends StatelessWidget {
  final TextEditingController addressController;
  final bool Function() validator;
  final int amount;

  const WithdrawFundsAddressNextButton({
    Key? key,
    required this.addressController,
    required this.validator,
    required this.amount,
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
            Navigator.of(context).push(
              FadeInRoute(
                builder: (_) => WithdrawFundsConfirmationPage(addressController.text, amount),
              ),
            );
          }
        },
      ),
    );
  }
}

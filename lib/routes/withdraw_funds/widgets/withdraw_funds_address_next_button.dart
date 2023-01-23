import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/routes/withdraw_funds/confirmation_page/withdraw_funds_confirmation_page.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: SubmitButton(
            texts.withdraw_funds_action_next,
            () {
              if (validator()) {
                Navigator.of(context).push(
                  FadeInRoute(
                    builder: (_) => WithdrawFundsConfirmationPage(
                      toAddress: addressController.text,
                      walletBalance: state.walletBalance,
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}

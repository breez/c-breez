import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/credential_manager.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/designsystem/switch/simple_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityMnemonicsManagement extends StatelessWidget {
  const SecurityMnemonicsManagement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountBloc accountBloc = context.read();

    return StreamBuilder<AccountState>(
      stream: accountBloc.stream,
      builder: (context, accountStateSnapshot) {
        if (!accountStateSnapshot.hasData) {
          return Container();
        }
        final accountState = accountStateSnapshot.data!;

        return SimpleSwitch(
          text: "Verify Mnemonics",
          switchValue: accountState.verificationStatus == VerificationStatus.VERIFIED,
          onChanged: (bool value) async {
            if (value) {
              await ServiceInjector().keychain.read(CredentialsManager.accountMnemonic).then(
                    (accountMnemonic) => Navigator.pushNamed(
                      context,
                      "/mnemonics",
                      arguments: accountMnemonic,
                    ),
                  );
            } else {
              return;
            }
          },
        );
      },
    );
  }
}

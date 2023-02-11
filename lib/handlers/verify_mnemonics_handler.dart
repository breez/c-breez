import 'dart:async';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/routes/initial_walkthrough/mnemonics/verify_mnemonics_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';

class MnemonicsVerificationHandler {
  final _log = FimberLog("MnemonicsVerificationHandler");

  final BuildContext context;
  final AccountBloc accountBloc;

  MnemonicsVerificationHandler(this.context, this.accountBloc) {
    if (accountBloc.state.verificationStatus == VerificationStatus.UNVERIFIED) {
      _log.v("MnemonicsVerificationHandler created");
      late StreamSubscription streamSubscription;
      streamSubscription = accountBloc.stream
          .where((state) => state.payments.isNotEmpty)
          .distinct((previous, next) => previous.payments.length == next.payments.length)
          .listen(
        (accountStatus) async {
          if (accountStatus.verificationStatus == VerificationStatus.VERIFIED) {
            _log.v("Mnemonics are verified. Stop listening to stream");
            streamSubscription.cancel();
          }
          _log.v("Received new payment. Displaying verify mnemonics dialog.");
          popFlushbars(context);
          showDialog(
            useRootNavigator: false,
            barrierDismissible: false,
            context: context,
            builder: (_) => const VerifyMnemonicsDialog(),
          );
        },
      );
    }
  }
}

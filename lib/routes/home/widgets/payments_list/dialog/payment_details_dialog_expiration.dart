import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentDetailsDialogExpiration extends StatelessWidget {
  final PaymentMinutiae paymentMinutiae;
  final AutoSizeGroup? labelAutoSizeGroup;

  const PaymentDetailsDialogExpiration({
    super.key,
    required this.paymentMinutiae,
    this.labelAutoSizeGroup,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    if (paymentMinutiae.status == PaymentStatus.Complete) {
      return Container();
    }

    final pendingExpirationBlock = paymentMinutiae.pendingExpirationBlock;
    final currentBlockHeight = context.select<AccountBloc, int>((value) => value.state.blockheight);

    if (pendingExpirationBlock != null && pendingExpirationBlock > currentBlockHeight) {
      return Container(
        height: 36.0,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AutoSizeText(
                texts.payment_details_dialog_expiration,
                style: themeData.primaryTextTheme.headlineMedium,
                textAlign: TextAlign.left,
                maxLines: 1,
                group: labelAutoSizeGroup,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                padding: const EdgeInsets.only(left: 8.0),
                child: AutoSizeText(
                  BreezDateUtils.formatYearMonthDayHourMinute(
                    BreezDateUtils.blockDiffToDate(
                      blockHeight: currentBlockHeight,
                      expiryBlock: pendingExpirationBlock,
                    ),
                  ),
                  style: themeData.primaryTextTheme.displaySmall,
                  textAlign: TextAlign.right,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

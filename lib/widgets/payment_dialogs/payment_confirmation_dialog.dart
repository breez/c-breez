import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationDialog extends StatelessWidget {
  final String bolt11;
  final int _amountToPay;
  final String _amountToPayStr;
  final Function() _onCancel;
  final Function(String bolt11, int amount) _onPaymentApproved;
  final double minHeight;

  const PaymentConfirmationDialog(
    this.bolt11,
    this._amountToPay,
    this._amountToPayStr,
    this._onCancel,
    this._onPaymentApproved,
    this.minHeight, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: _buildConfirmationDialog(context),
        ),
      ),
    );
  }

  List<Widget> _buildConfirmationDialog(BuildContext context) {
    return [
      _buildTitle(context),
      _buildContent(context),
      _buildActions(context),
    ];
  }

  Container _buildTitle(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Container(
      height: 64.0,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        texts.payment_confirmation_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);
    final texts = context.texts();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: SizedBox(
        width: queryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texts.payment_confirmation_dialog_confirmation,
              style: themeData.dialogTheme.contentTextStyle,
              textAlign: TextAlign.center,
            ),
            AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: _amountToPayStr,
                    style: themeData.dialogTheme.contentTextStyle!.copyWith(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: texts.payment_confirmation_dialog_confirmation_end,
                  )
                ],
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              style: themeData.dialogTheme.contentTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    List<Widget> children = [
      TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.transparent;
            }
            // Defer to the widget's default.
            return themeData.textTheme.labelLarge!.color!;
          }),
        ),
        child: Text(
          texts.payment_confirmation_dialog_action_no,
          style: themeData.primaryTextTheme.labelLarge,
        ),
        onPressed: () => _onCancel(),
      ),
      TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.transparent;
            }
            // Defer to the widget's default.
            return themeData.textTheme.labelLarge!.color!;
          }),
        ),
        child: Text(
          texts.payment_confirmation_dialog_action_yes,
          style: themeData.primaryTextTheme.labelLarge,
        ),
        onPressed: () {
          _onPaymentApproved(
            bolt11,
            _amountToPay,
          );
        },
      ),
    ];

    return SizedBox(
      height: 64.0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}

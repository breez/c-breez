import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/payment_info.dart';
import 'package:c_breez/models/payment_type.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flip_transition.dart';
import 'payment_details_dialog.dart';
import 'payment_item_avatar.dart';
import 'success_avatar.dart';

class PaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final bool _firstItem;
  final bool _hideBalance;
  final GlobalKey firstPaymentItemKey;

  const PaymentItem(
    this._paymentInfo,
    this._firstItem,
    this._hideBalance,
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: theme.customData[theme.themeId]!.paymentListBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Container(
                  height: 72.0,
                  decoration: _createdWithin(const Duration(seconds: 10))
                      ? BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0.5, 0.5),
                              blurRadius: 5.0,
                            ),
                          ],
                        )
                      : null,
                  child: _buildPaymentItemAvatar(),
                ),
                key: _firstItem ? firstPaymentItemKey : null,
                title: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Text(
                    _paymentInfo.shortTitle,
                    style: themeData.textTheme.subtitle2?.copyWith(
                      color: themeData.colorScheme.onSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        BreezDateUtils.formatTimelineRelative(
                          DateTime.fromMillisecondsSinceEpoch(
                            _paymentInfo.creationTimestamp.toInt() * 1000,
                          ),
                        ),
                        style: themeData.textTheme.caption?.copyWith(
                          color: themeData.colorScheme.onSecondary,
                        ),
                      ),
                      _pendingSuffix(context),
                    ],
                  ),
                ),
                trailing: SizedBox(
                  height: 44,
                  child: BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, currencyState) {
                      return Column(
                        mainAxisAlignment:
                            _paymentInfo.feeSat == 0 || _paymentInfo.pending
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _paymentAmount(context, currencyState),
                          _paymentFee(context, currencyState),
                        ],
                      );
                    },
                  ),
                ),
                onTap: () => _showDetail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pendingSuffix(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return _paymentInfo.pending
        ? Text(
            texts.wallet_dashboard_payment_item_balance_pending_suffix,
            style: themeData.textTheme.caption!.copyWith(
              color: theme.customData[theme.themeId]!.pendingTextColor,
            ),
          )
        : const SizedBox();
  }

  Widget _paymentAmount(
    BuildContext context,
    CurrencyState currencyState,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final amount = currencyState.bitcoinCurrency.format(
      _paymentInfo.amountSat!,
      includeDisplayName: false,
    );

    return Text(
      _hideBalance
          ? texts.wallet_dashboard_payment_item_balance_hide
          : _paymentInfo.type.isIncome
              ? texts.wallet_dashboard_payment_item_balance_positive(amount)
              : texts.wallet_dashboard_payment_item_balance_negative(amount),
      style: themeData.textTheme.headline6?.copyWith(
        color: themeData.colorScheme.onSecondary,
      ),
    );
  }

  Widget _paymentFee(
    BuildContext context,
    CurrencyState currencyState,
  ) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    final fee = _paymentInfo.feeSat;
    if (fee == 0 || _paymentInfo.pending) return const SizedBox();
    final feeFormatted = currencyState.bitcoinCurrency.format(
      fee,
      includeDisplayName: false,
    );

    return Text(
      _hideBalance
          ? texts.wallet_dashboard_payment_item_balance_hide
          : texts.wallet_dashboard_payment_item_balance_fee(feeFormatted),
      style: themeData.textTheme.caption?.copyWith(
        color: themeData.colorScheme.onSecondary,
      ),
    );
  }

  Widget _buildPaymentItemAvatar() {
    if (_createdWithin(const Duration(seconds: 10))) {
      return PaymentItemAvatar(_paymentInfo, radius: 16);
    } else {
      return FlipTransition(
        PaymentItemAvatar(
          _paymentInfo,
          radius: 16,
        ),
        const SuccessAvatar(radius: 16),
        radius: 16,
      );
    }
  }

  bool _createdWithin(Duration duration) {
    final diff = DateTime.fromMillisecondsSinceEpoch(
      _paymentInfo.creationTimestamp.toInt() * 1000,
    ).difference(
      DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return diff < -duration;
  }

  void _showDetail(BuildContext context) {
    showPaymentDetailsDialog(context, _paymentInfo);
  }
}

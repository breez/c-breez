import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/payment_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flip_transition.dart';
import 'payment_item_avatar.dart';
import 'success_avatar.dart';

const DASHBOARD_MAX_HEIGHT = 202.25;
const DASHBOARD_MIN_HEIGHT = 70.0;
const FILTER_MAX_SIZE = 64.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;
const BOTTOM_PADDING = 8.0;
const AVATAR_DIAMETER = 24.0;

class PaymentItem extends StatelessWidget {
  final PaymentInfo _paymentInfo;
  final int _itemIndex;
  final bool _firstItem;
  final bool _hideBalance;
  final GlobalKey firstPaymentItemKey;
  final ScrollController _scrollController;

  const PaymentItem(
    this._paymentInfo,
    this._itemIndex,
    this._firstItem,
    this._hideBalance,
    this.firstPaymentItemKey,
    this._scrollController,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BOTTOM_PADDING, left: 8, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: theme.customData[theme.themeId]!.paymentListBgColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Opacity(
                  // when the transaction list is fully expanded
                  // set opacity the avatar of the item that's
                  // no longer visible to transparent
                  opacity: (_scrollController.offset -
                              (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                              ((PAYMENT_LIST_ITEM_HEIGHT + BOTTOM_PADDING) *
                                      (_itemIndex + 1) -
                                  FILTER_MAX_SIZE +
                                  AVATAR_DIAMETER) >
                          0)
                      ? 0.0
                      : 1.0,
                  child: Container(
                      height: PAYMENT_LIST_ITEM_HEIGHT,
                      decoration: _createdWithin(const Duration(seconds: 10))
                          ? BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: const Offset(0.5, 0.5),
                                    blurRadius: 5.0),
                              ],
                            )
                          : null,
                      child: _buildPaymentItemAvatar()),
                ),
                key: _firstItem ? firstPaymentItemKey : null,
                title: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Opacity(
                    // set title text to transparent when it leaves viewport
                    opacity: (_scrollController.offset -
                                (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                                ((PAYMENT_LIST_ITEM_HEIGHT + BOTTOM_PADDING) *
                                        (_itemIndex + 1) -
                                    FILTER_MAX_SIZE +
                                    AVATAR_DIAMETER / 2) >
                            0)
                        ? 0.0
                        : 1.0,
                    child: Text(
                      () {
                        return _paymentInfo.shortTitle;
                      }()
                          .replaceAll("\n", " "),
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                subtitle: Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          BreezDateUtils.formatTimelineRelative(
                              DateTime.fromMillisecondsSinceEpoch(
                                  _paymentInfo.creationTimestamp.toInt() *
                                      1000)),
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                        ),
                        _paymentInfo.pending
                            ? Text(" (Pending)",
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: theme.customData[theme.themeId]!
                                            .pendingTextColor))
                            : const SizedBox()
                      ]),
                ),
                trailing: SizedBox(
                  height: 44,
                  child: BlocBuilder<CurrencyBoc, CurrencyState>(
                      builder: (context, currencyState) {
                    return Column(
                      mainAxisAlignment:
                          _paymentInfo.fee == 0 || _paymentInfo.pending
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        _paymentAmount(context, currencyState),
                        _paymentFee(context, currencyState),
                      ],
                    );
                  }),
                ),
                onTap: () => _showDetail(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentAmount(BuildContext context, CurrencyState currencyState) {
    final type = _paymentInfo.type;
    final negative = type == PaymentType.SENT;
    final amount = currencyState.bitcoinCurrency.format(
      _paymentInfo.amountSat,
      includeDisplayName: false,
    );
    return Opacity(
      // set amount text to transparent when it leaves viewport
      opacity: (_scrollController.offset -
                  (DASHBOARD_MAX_HEIGHT - DASHBOARD_MIN_HEIGHT) -
                  ((PAYMENT_LIST_ITEM_HEIGHT + BOTTOM_PADDING) *
                          (_itemIndex + 1) -
                      FILTER_MAX_SIZE +
                      AVATAR_DIAMETER / 2) >
              0)
          ? 0.0
          : 1.0,
      child: Text(
        _hideBalance ? "******" : (negative ? "- " : "+ ") + amount,
        style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
      ),
    );
  }

  Widget _paymentFee(BuildContext context, CurrencyState currencyState) {
    final fee = _paymentInfo.fee;
    if (fee == 0 || _paymentInfo.pending) return const SizedBox();
    final feeFormatted = currencyState.bitcoinCurrency.format(
      fee,
      includeDisplayName: false,
    );
    return Text(
      _hideBalance ? "******" : "FEE $feeFormatted",
      style: Theme.of(context).textTheme.caption?.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
    );
  }

  Widget _buildPaymentItemAvatar() {
    // Show Flip Transition if the payment item is created within last 10 seconds
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
    return DateTime.fromMillisecondsSinceEpoch(
                _paymentInfo.creationTimestamp.toInt() * 1000)
            .difference(DateTime.fromMillisecondsSinceEpoch(
                DateTime.now().millisecondsSinceEpoch)) <
        -duration;
  }

  void _showDetail(BuildContext context) {
    showPaymentDetailsDialog(context, _paymentInfo);
  }
}

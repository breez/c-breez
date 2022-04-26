import 'package:c_breez/models/account.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:flutter/material.dart';

import 'payment_item.dart';

const BOTTOM_PADDING = 8.0;

class PaymentsList extends StatefulWidget {
  final UserProfileSettings _userModel;
  final List<PaymentInfo> _payments;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  const PaymentsList(
    this._userModel,
    this._payments,
    this._itemHeight,
    this.firstPaymentItemKey,
    this.scrollController,
  );

  @override
  State<StatefulWidget> createState() {
    return PaymentsListState();
  }
}

class PaymentsListState extends State<PaymentsList> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScroll);
    super.dispose();
  }

  void onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList(
      itemExtent: widget._itemHeight + BOTTOM_PADDING,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        final payment = widget._payments[index];
        return PaymentItem(
          payment,
          index,
          0 == index,
          widget._userModel.hideBalance,
          widget.firstPaymentItemKey,
          widget.scrollController,
        );
      }, childCount: widget._payments.length),
    );
  }
}

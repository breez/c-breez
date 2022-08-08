import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:breez_sdk/sdk.dart' as breez_sdk;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_item.dart';

const _kBottomPadding = 8.0;

class PaymentsList extends StatelessWidget {
  final List<breez_sdk.PaymentInfo> _payments;
  final double _itemHeight;
  final GlobalKey firstPaymentItemKey;

  const PaymentsList(
    this._payments,
    this._itemHeight,
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, userModel) {
        return SliverFixedExtentList(
          itemExtent: _itemHeight + _kBottomPadding,
          delegate: SliverChildBuilderDelegate(
            (context, index) => PaymentItem(
              _payments[index],
              0 == index,
              userModel.profileSettings.hideBalance,
              firstPaymentItemKey,
            ),
            childCount: _payments.length,
          ),
        );
      },
    );
  }
}

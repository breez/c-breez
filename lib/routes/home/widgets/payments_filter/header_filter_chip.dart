import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fixed_sliver_delegate.dart';

class HeaderFilterChip extends SliverPadding {
  HeaderFilterChip(double maxHeight, DateTime startDate, DateTime endDate, {super.key})
    : super(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        sliver: SliverPersistentHeader(
          pinned: true,
          delegate: FixedSliverDelegate(
            maxHeight / 1.2,
            builder: (context, height, overlap) {
              final customData = Theme.of(context).customData;
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                height: maxHeight / 1.2,
                color: customData.dashboardBgColor,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: customData.paymentListBgColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                          child: Chip(
                            label: Text(BreezDateUtils.formatFilterDateRange(startDate, endDate)),
                            onDeleted: () => context.read<AccountBloc>().changePaymentFilter(
                              toTimestamp: null,
                              fromTimestamp: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

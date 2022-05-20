import 'package:c_breez/routes/home/widgets/payments_filter/fixed_sliver_delegate.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class PaymentsFilterSliver extends StatelessWidget {
  final double _size;

  const PaymentsFilterSliver(
    this._size, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customData = theme.customData[theme.themeId]!;

    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedSliverDelegate(
        _size,
        builder: (context, height, overlapContent) {
          return Container(
            color: customData.dashboardBgColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: customData.paymentListBgColor,
                  height: _size,
                  child: const PaymentsFilter(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

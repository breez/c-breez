import 'package:c_breez/routes/home/wallet_dashboard.dart';
import 'package:flutter/material.dart';

const kMaxExtent = 200.0;
const kMinExtent = 70.0;

class WalletDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  const WalletDashboardHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return WalletDashboard(
      (kMaxExtent - shrinkOffset).clamp(kMinExtent, kMaxExtent),
      (shrinkOffset / (kMaxExtent - kMinExtent)).clamp(0.0, 1.0),
    );
  }

  @override
  double get maxExtent => kMaxExtent;

  @override
  double get minExtent => kMinExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return snapConfiguration != oldDelegate.snapConfiguration;
  }
}

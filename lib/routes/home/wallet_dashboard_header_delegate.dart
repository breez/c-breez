import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/home/wallet_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kDashboardMaxHeight = 202.25;
const kDashboardMinHeight = 70.0;

class WalletDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  const WalletDashboardHeaderDelegate();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return BlocBuilder<CurrencyBoc, CurrencyState>(
      builder: (context, currencyState) {
        return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (settingCtx, userState) {
            return BlocBuilder<AccountBloc, AccountState>(
              builder: (context, accountState) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    WalletDashboard(
                      userState.profileSettings,
                      accountState,
                      currencyState,
                      (maxExtent - shrinkOffset).clamp(minExtent, maxExtent),
                      (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0),
                      context.read<CurrencyBoc>().setBitcoinTicker,
                      context.read<CurrencyBoc>().setFiatShortName,
                      (hideBalance) => context
                          .read<UserProfileBloc>()
                          .updateProfile(hideBalance: true),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  double get maxExtent => kDashboardMaxHeight;

  @override
  double get minExtent => kDashboardMinHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

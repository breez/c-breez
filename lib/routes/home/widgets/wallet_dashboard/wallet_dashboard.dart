import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_cubit.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/home/widgets/wallet_dashboard/wallet_dashboard.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'widgets/widgets.dart';

const double _kBalanceOffsetTransition = 60.0;

class WalletDashboard extends StatefulWidget {
  final double height;
  final double offsetFactor;

  const WalletDashboard({required this.height, required this.offsetFactor, super.key});

  @override
  State<WalletDashboard> createState() => _WalletDashboardState();
}

class _WalletDashboardState extends State<WalletDashboard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return BlocBuilder<SdkConnectivityCubit, SdkConnectivityState>(
      builder: (context, sdkConnectivityState) {
        return BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (BuildContext context, CurrencyState currencyState) {
            return BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (BuildContext context, UserProfileState userProfileState) {
                return BlocBuilder<AccountBloc, AccountState>(
                  builder: (BuildContext context, AccountState accountState) {
                    final bool hiddenBalance = userProfileState.profileSettings.hideBalance;
                    final bool showBalance = sdkConnectivityState == SdkConnectivityState.connected;

                    return Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: widget.height,
                          decoration: BoxDecoration(color: themeData.customData.dashboardBgColor),
                        ),
                        Positioned(
                          top: 60 - _kBalanceOffsetTransition * widget.offsetFactor,
                          child: showBalance
                              ? BalanceText(
                                  hiddenBalance: hiddenBalance,
                                  currencyState: currencyState,
                                  accountState: accountState,
                                  offsetFactor: widget.offsetFactor,
                                )
                              : PlaceholderBalanceText(offsetFactor: widget.offsetFactor),
                        ),
                        Positioned(
                          top: 100 - _kBalanceOffsetTransition * widget.offsetFactor,
                          child: FiatBalanceText(
                            hiddenBalance: hiddenBalance,
                            currencyState: currencyState,
                            accountState: accountState,
                            offsetFactor: widget.offsetFactor,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

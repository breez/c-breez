import 'package:breez_sdk/sdk.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_cubit.dart';
import 'package:c_breez/bloc/sdk_connectivity/sdk_connectivity_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/home/widgets/bubble_painter.dart';
import 'package:c_breez/routes/home/widgets/no_lsp_widget.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/fixed_sliver_delegate.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/header_filter_chip.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_sliver.dart';
import 'package:c_breez/routes/home/widgets/payments_list/payments_list.dart';
import 'package:c_breez/routes/home/widgets/payments_list/placeholder_payment_item.dart';
import 'package:c_breez/routes/home/widgets/status_text.dart';
import 'package:c_breez/routes/home/widgets/wallet_dashboard/wallet_dashboard.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

const _kFilterMaxSize = 64.0;
const _kPaymentListItemHeight = 72.0;
const int _kPlaceholderListItemCount = 8;

final _log = Logger("AccountPage");

class AccountPage extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  const AccountPage(this.firstPaymentItemKey, this.scrollController, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SdkConnectivityCubit, SdkConnectivityState>(
      builder: (context, sdkConnectivityState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, accountState) {
            return BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, userModel) {
                _log.info("AccountPage build with ${accountState.payments.length} payments");
                return Container(
                  color: Theme.of(context).customData.dashboardBgColor,
                  child: _build(context, sdkConnectivityState, accountState, userModel),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    SdkConnectivityState sdkConnectivityState,
    AccountState accountState,
    UserProfileState userModel,
  ) {
    final nonFilteredPayments = accountState.payments;
    final paymentFilters = accountState.paymentFilters;
    final filteredPayments = context.read<AccountBloc>().filterPaymentList();

    List<Widget> slivers = [];

    slivers.add(
      const SliverPersistentHeader(floating: false, delegate: WalletDashboardHeaderDelegate(), pinned: true),
    );

    final bool showSliver =
        nonFilteredPayments.isNotEmpty || paymentFilters.filters != PaymentTypeFilter.values;
    int? startDate = paymentFilters.fromTimestamp;
    int? endDate = paymentFilters.toTimestamp;
    bool hasDateFilter = startDate != null && endDate != null;
    if (showSliver) {
      slivers.add(
        PaymentsFilterSliver(
          maxSize: _kFilterMaxSize,
          scrollController: scrollController,
          hasFilter: paymentFilters.filters != PaymentTypeFilter.values || hasDateFilter,
        ),
      );
    }

    if (hasDateFilter) {
      slivers.add(
        HeaderFilterChip(
          _kFilterMaxSize,
          DateTime.fromMillisecondsSinceEpoch(startDate),
          DateTime.fromMillisecondsSinceEpoch(endDate),
        ),
      );
    }

    if (showSliver) {
      slivers.add(PaymentsList(filteredPayments, _kPaymentListItemHeight, firstPaymentItemKey));
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: FixedSliverDelegate(
            _bottomPlaceholderSpace(
              context,
              hasDateFilter,
              nonFilteredPayments.isEmpty ? _kPlaceholderListItemCount : filteredPayments.length,
            ),
            child: Container(),
          ),
        ),
      );
    } else if (!accountState.initial && nonFilteredPayments.isEmpty) {
      slivers.add(
        SliverFixedExtentList(
          itemExtent: _kPaymentListItemHeight + 8.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) => const PlaceholderPaymentItem(),
            childCount: _kPlaceholderListItemCount,
          ),
        ),
      );
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: FixedSliverDelegate(
            _bottomPlaceholderSpace(
              context,
              hasDateFilter,
              nonFilteredPayments.isEmpty ? _kPlaceholderListItemCount : filteredPayments.length,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      );
    } else {
      slivers.add(
        SliverPersistentHeader(
          delegate: FixedSliverDelegate(
            250.0,
            builder: (context, shrinkedHeight, overlapContent) {
              return BlocBuilder<LSPBloc, LspState?>(
                builder: (context, lspState) {
                  var isConnecting = sdkConnectivityState == SdkConnectivityState.connecting;
                  if (!isConnecting && lspState != null && lspState.selectedLspId == null) {
                    return const Padding(padding: EdgeInsets.only(top: 120.0), child: NoLSPWidget());
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(40.0, 120.0, 40.0, 0.0),
                    child: StatusText(
                      sdkConnectivityState: sdkConnectivityState,
                      accountState: accountState,
                      lspState: lspState,
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    }

    return Container(
      color: Theme.of(context).customData.dashboardBgColor,
      child: Stack(
        key: const Key('account_sliver'),
        fit: StackFit.expand,
        children: <Widget>[
          if (!showSliver && !(accountState.initial && nonFilteredPayments.isEmpty)) ...<Widget>[
            CustomPaint(painter: BubblePainter(context)),
          ],
          CustomScrollView(controller: scrollController, slivers: slivers),
        ],
      ),
    );
  }

  double _bottomPlaceholderSpace(BuildContext context, bool hasDateFilters, int paymentsSize) {
    if (paymentsSize == 0) {
      return 0.0;
    }

    final Size screenSize = MediaQuery.of(context).size;
    final double listHeightSpace = screenSize.height - kMinExtent - kToolbarHeight - _kFilterMaxSize - 25.0;
    final double dateFilterSpace = hasDateFilters ? 0.65 : 0.0;
    final double requiredSpace = (_kPaymentListItemHeight + 8) * (paymentsSize + 1 + dateFilterSpace);
    return (listHeightSpace - requiredSpace).clamp(0.0, listHeightSpace);
  }
}

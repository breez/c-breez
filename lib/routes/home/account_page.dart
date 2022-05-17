import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/routes/home/bubble_painter.dart';
import 'package:c_breez/routes/home/header_filter_chip.dart';
import 'package:c_breez/routes/home/wallet_dashboard_header_delegate.dart';
import 'package:c_breez/routes/lsp/no_lsp_widget.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/fixed_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payments_filter.dart';
import 'payments_list.dart';
import 'status_text.dart';

const _kFilterMaxSize = 64.0;
const _kFilterMinSize = 0.0;
const _kPaymentListItemHeight = 72.0;

class AccountPage extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  const AccountPage(
    this.firstPaymentItemKey,
    this.scrollController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LSPState>(
      builder: (context, lspState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, account) {
            return BlocBuilder<UserProfileBloc, UserProfileState>(
              builder: (context, userModel) {
                return Container(
                  color: theme.customData[theme.themeId]!.dashboardBgColor,
                  child: _build(
                    context,
                    lspState,
                    account,
                    userModel,
                  ),
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
    LSPState lspState,
    AccountState account,
    UserProfileState userModel,
  ) {
    final payment = account.payments;
    final payments = payment.paymentsList;
    final nonFiltered = payment.nonFilteredItems;

    List<Widget> slivers = [];

    slivers.add(
      const SliverPersistentHeader(
        floating: false,
        delegate: WalletDashboardHeaderDelegate(),
        pinned: true,
      ),
    );

    if (nonFiltered.isNotEmpty) {
      slivers.add(
        PaymentFilterSliver(
          scrollController,
          _kFilterMinSize,
          _kFilterMaxSize,
          payment,
        ),
      );
    }

    final paymentTypes = payment.filter.paymentType;
    final startDate = payment.filter.startDate;
    final endDate = payment.filter.endDate;
    if (startDate != null && endDate != null) {
      slivers.add(
        HeaderFilterChip(_kFilterMaxSize, paymentTypes, startDate, endDate),
      );
    }

    if (nonFiltered.isNotEmpty) {
      slivers.add(
        PaymentsList(
          payments,
          _kPaymentListItemHeight,
          firstPaymentItemKey,
        ),
      );
      slivers.add(
        SliverPersistentHeader(
          pinned: true,
          delegate: FixedSliverDelegate(
            _bottomPlaceholderSpace(context, payment, payments),
            child: Container(),
          ),
        ),
      );
    } else if (!account.initial) {
      slivers.add(
        SliverPersistentHeader(
          delegate: FixedSliverDelegate(
            250.0,
            builder: (context, shrinkedHeight, overlapContent) {
              if (lspState.selectionRequired == true) {
                return const Padding(
                  padding: EdgeInsets.only(top: 120.0),
                  child: NoLSPWidget(),
                );
              }
              return const Padding(
                padding: EdgeInsets.fromLTRB(40.0, 120.0, 40.0, 0.0),
                child: StatusText(message: ""),
              );
            },
          ),
        ),
      );
    }

    return Stack(
      key: const Key("account_sliver"),
      fit: StackFit.expand,
      children: [
        nonFiltered.isEmpty
            ? CustomPaint(painter: BubblePainter(MediaQuery.of(context).size))
            : const SizedBox(),
        CustomScrollView(
          controller: scrollController,
          slivers: slivers,
        ),
      ],
    );
  }

  double _bottomPlaceholderSpace(
    BuildContext context,
    PaymentsState payment,
    List<PaymentInfo> payments,
  ) {
    if (payments.isEmpty) return 0.0;
    double listHeightSpace = MediaQuery.of(context).size.height -
        kMinExtent -
        kToolbarHeight -
        _kFilterMaxSize -
        25.0;
    double dateFilterSpace = payment.filter.endDate != null ? 0.65 : 0.0;
    double bottomPlaceholderSpace = (listHeightSpace -
            (_kPaymentListItemHeight + 8) *
                (payments.length + 1 + dateFilterSpace))
        .clamp(0.0, listHeightSpace);
    return bottomPlaceholderSpace;
  }
}

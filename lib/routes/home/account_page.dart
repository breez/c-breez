import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/home/bubble_painter.dart';
import 'package:c_breez/routes/home/wallet_dashboard_header_delegate.dart';
import 'package:c_breez/routes/lsp/no_lsp_widget.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/fixed_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payments_filter.dart';
import 'payments_list.dart';
import 'status_text.dart';

const FILTER_MAX_SIZE = 64.0;
const FILTER_MIN_SIZE = 0.0;
const PAYMENT_LIST_ITEM_HEIGHT = 72.0;

class AccountPage extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;

  const AccountPage(this.firstPaymentItemKey, this.scrollController);

  @override
  State<StatefulWidget> createState() {
    return AccountPageState();
  }
}

class AccountPageState extends State<AccountPage>
    with SingleTickerProviderStateMixin {
  final List<String> currencyList =
      BitcoinCurrency.currencies.map((c) => c.tickerSymbol).toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LSPState>(builder: (context, lspState) {
      return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, account) {
        return BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (context, userModel) {
          return Container(
            color: theme.customData[theme.themeId]!.dashboardBgColor,
            child: _buildBalanceAndPayments(
              context,
              lspState,
              account,
              userModel,
            ),
          );
        });
      });
    });
  }

  Widget _buildBalanceAndPayments(
    BuildContext context,
    LSPState lspState,
    AccountState account,
    UserProfileState userModel,
  ) {
    double listHeightSpace = MediaQuery.of(context).size.height -
        kDashboardMinHeight -
        kToolbarHeight -
        FILTER_MAX_SIZE -
        25.0;
    double dateFilterSpace =
        account.payments.filter.endDate != null ? 0.65 : 0.0;
    double bottomPlaceholderSpace = account.payments.paymentsList.isEmpty
        ? 0.0
        : (listHeightSpace -
                (PAYMENT_LIST_ITEM_HEIGHT + 8) *
                    (account.payments.paymentsList.length +
                        1 +
                        dateFilterSpace))
            .clamp(0.0, listHeightSpace);

    String message = "";
    bool showMessage = !account.initial;

    List<Widget> slivers = <Widget>[];
    slivers.add(SliverPersistentHeader(
        floating: false,
        delegate: WalletDashboardHeaderDelegate(),
        pinned: true));
    if (account.payments.nonFilteredItems.isNotEmpty) {
      slivers.add(PaymentFilterSliver(widget.scrollController, FILTER_MIN_SIZE,
          FILTER_MAX_SIZE, account.payments));
    }
    slivers.add(SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      sliver: SliverPersistentHeader(
        pinned: true,
        delegate: FixedSliverDelegate(FILTER_MAX_SIZE / 1.2,
            builder: (context, shrinkedHeight, overlapContent) {
          return Container(
            padding: const EdgeInsets.only(bottom: 8),
            height: FILTER_MAX_SIZE / 1.2,
            color: theme.customData[theme.themeId]!.dashboardBgColor,
            child: _buildDateFilterChip(account.payments.filter),
          );
        }),
      ),
    ));

    if (account.payments.nonFilteredItems.isNotEmpty) {
      slivers.add(PaymentsList(
        userModel.profileSettings,
        account.payments.paymentsList,
        PAYMENT_LIST_ITEM_HEIGHT,
        widget.firstPaymentItemKey,
        widget.scrollController,
      ));
      slivers.add(SliverPersistentHeader(
          pinned: true,
          delegate:
              FixedSliverDelegate(bottomPlaceholderSpace, child: Container())));
    } else if (showMessage) {
      slivers.add(SliverPersistentHeader(
          delegate: FixedSliverDelegate(250.0,
              builder: (context, shrinkedHeight, overlapContent) {
        if (lspState.selectionRequired == true) {
          return const Padding(
            padding: EdgeInsets.only(top: 120.0),
            child: NoLSPWidget(),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 120.0, left: 40.0, right: 40.0),
          child: StatusText(account, message: message),
        );
      })));
    }

    return Stack(
      key: const Key("account_sliver"),
      fit: StackFit.expand,
      children: [
        account.payments.nonFilteredItems.isEmpty
            ? CustomPaint(painter: BubblePainter(MediaQuery.of(context).size))
            : const SizedBox(),
        CustomScrollView(controller: widget.scrollController, slivers: slivers),
      ],
    );
  }

  _buildDateFilterChip(PaymentFilterModel filter) {
    return (filter.endDate != null) ? _filterChip(filter) : Container();
  }

  Widget _filterChip(PaymentFilterModel filter) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: theme.customData[theme.themeId]!.paymentListBgColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 16.0, bottom: 8),
              child: Chip(
                  label: Text(BreezDateUtils.formatFilterDateRange(
                      filter.startDate!, filter.endDate!)),
                  onDeleted: () => context
                      .read<AccountBloc>()
                      .changePaymentFilter(
                          PaymentFilterModel(filter.paymentType, null, null))),
            ),
          ],
        ),
      ),
    );
  }
}
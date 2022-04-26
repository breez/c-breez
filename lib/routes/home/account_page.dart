import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/theme_data.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:c_breez/widgets/fixed_sliver_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payments_filter.dart';
import 'payments_list.dart';
import 'status_text.dart';
import 'wallet_dashboard.dart';

const DASHBOARD_MAX_HEIGHT = 202.25;
const DASHBOARD_MIN_HEIGHT = 70.0;
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
        DASHBOARD_MIN_HEIGHT -
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
            child: NoLSPWidget(
              error: "LSP is not connected",
            ),
          );
        }
        return Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 120.0, left: 40.0, right: 40.0),
            child: StatusText(account, message: message),
          ),
        );
      })));
    }

    return Stack(
      key: const Key("account_sliver"),
      fit: StackFit.expand,
      children: [
        account.payments.nonFilteredItems.isEmpty
            ? CustomPaint(painter: BubblePainter(context))
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
                  backgroundColor: Theme.of(context).bottomAppBarColor,
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

class BubblePainter extends CustomPainter {
  BuildContext context;

  BubblePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var bubblePaint = Paint()
      ..color = theme.themeId == "BLUE"
          ? const Color(0xFF0085fb).withOpacity(0.1)
          : const Color(0xff4D88EC).withOpacity(0.1)
      ..style = PaintingStyle.fill;
    double bubbleRadius = 12;
    double height = (MediaQuery.of(context).size.height - kToolbarHeight);
    canvas.drawCircle(
        Offset(MediaQuery.of(context).size.width / 2, height * 0.36),
        bubbleRadius,
        bubblePaint);
    canvas.drawCircle(
        Offset(MediaQuery.of(context).size.width * 0.39, height * 0.59),
        bubbleRadius * 1.5,
        bubblePaint);
    canvas.drawCircle(
        Offset(MediaQuery.of(context).size.width * 0.65, height * 0.71),
        bubbleRadius * 1.25,
        bubblePaint);
    canvas.drawCircle(
        Offset(MediaQuery.of(context).size.width / 2, height * 0.80),
        bubbleRadius * 0.75,
        bubblePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class WalletDashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  WalletDashboardHeaderDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return BlocBuilder<CurrencyBoc, CurrencyState>(
        builder: (context, currencyState) {
      return BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (settingCtx, userState) {
        return BlocBuilder<AccountBloc, AccountState>(
            builder: (context, accountState) {
          double height =
              (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
          double heightFactor =
              (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

          return Stack(clipBehavior: Clip.none, children: <Widget>[
            WalletDashboard(
              userState.profileSettings,
              accountState,
              currencyState,
              height,
              heightFactor,
              context.read<CurrencyBoc>().setBitcoinTicker,
              context.read<CurrencyBoc>().setFiatShortName,
              (hideBalance) => context
                  .read<UserProfileBloc>()
                  .updateProfile(hideBalance: true),
            )
          ]);
        });
      });
    });
  }

  @override
  double get maxExtent => DASHBOARD_MAX_HEIGHT;

  @override
  double get minExtent => DASHBOARD_MIN_HEIGHT;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class NoLSPWidget extends StatelessWidget {
  final String error;

  const NoLSPWidget({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [
      SizedBox(
        height: 24.0,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              side: BorderSide(
                  color: Theme.of(context).textTheme.button!.color!,
                  style: BorderStyle.solid),
            ),
            child: Text("SELECT...",
                style: TextStyle(
                  fontSize: 12.3,
                  color: Theme.of(context).textTheme.button!.color!,
                )),
            onPressed: () {
              Navigator.of(context).pushNamed("/select_lsp");
            }),
      )
    ];

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: const <Widget>[
              Text("In order to activate Breez, please select a provider:")
            ],
          ),
          const SizedBox(height: 24),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: buttons)
        ]);
  }
}

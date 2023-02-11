import 'package:c_breez/handlers/check_version_handler.dart';
import 'package:c_breez/handlers/connectivity_handler.dart';
import 'package:c_breez/handlers/input_handler.dart';
import 'package:c_breez/handlers/payment_result_handler.dart';
import 'package:c_breez/handlers/verify_mnemonics_handler.dart';
import 'package:c_breez/routes/home/account_page.dart';
import 'package:c_breez/routes/home/widgets/app_bar/home_app_bar.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_actions_bar.dart';
import 'package:c_breez/routes/home/widgets/close_popup.dart';
import 'package:c_breez/routes/home/widgets/drawer/home_drawer.dart';
import 'package:c_breez/routes/home/widgets/fade_in_widget.dart';
import 'package:c_breez/routes/home/widgets/qr_action_button.dart';
import 'package:c_breez/routes/security/auto_lock_mixin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with AutoLockMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<HomeDrawerState> _drawerKey = GlobalKey<HomeDrawerState>();
  final GlobalKey firstPaymentItemKey = GlobalKey();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => initializeListeners(),
    );
  }

  void initializeListeners() {
    InputHandler(
      context,
      firstPaymentItemKey,
      scrollController,
      _scaffoldKey,
    );
    checkVersionDialog(context, context.read());
    ConnectivityHandler(context, context.read());
    PaymentResultHandler(context, context.read(), context.read());
    MnemonicsVerificationHandler(context, context.read());
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: willPopCallback(
        context,
        canCancel: () => _scaffoldKey.currentState?.isDrawerOpen ?? false,
      ),
      child: SizedBox(
        height: mediaSize.height,
        width: mediaSize.width,
        child: FadeInWidget(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            appBar: HomeAppBar(
              themeData: themeData,
              scaffoldKey: _scaffoldKey,
            ),
            drawerEnableOpenDragGesture: true,
            drawerDragStartBehavior: DragStartBehavior.down,
            drawerEdgeDragWidth: mediaSize.width,
            drawer: HomeDrawer(key: _drawerKey),
            bottomNavigationBar: BottomActionsBar(firstPaymentItemKey),
            floatingActionButton: QrActionButton(firstPaymentItemKey),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            body: _drawerKey.currentState?.screen() ?? AccountPage(firstPaymentItemKey, scrollController),
          ),
        ),
      ),
    );
  }
}

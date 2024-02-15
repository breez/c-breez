import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/handlers/check_version_handler.dart';
import 'package:c_breez/handlers/connectivity_handler.dart';
import 'package:c_breez/handlers/handler.dart';
import 'package:c_breez/handlers/handler_context_provider.dart';
import 'package:c_breez/handlers/health_check_handler.dart';
import 'package:c_breez/handlers/input_handler.dart';
import 'package:c_breez/handlers/payment_result_handler.dart';
import 'package:c_breez/routes/home/account_page.dart';
import 'package:c_breez/routes/home/widgets/app_bar/home_app_bar.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_actions_bar.dart';
import 'package:c_breez/routes/home/widgets/drawer/home_drawer.dart';
import 'package:c_breez/routes/home/widgets/fade_in_widget.dart';
import 'package:c_breez/routes/home/widgets/qr_action_button.dart';
import 'package:c_breez/routes/security/auto_lock_mixin.dart';
import 'package:c_breez/widgets/error_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with AutoLockMixin, HandlerContextProvider {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<HomeDrawerState> _drawerKey = GlobalKey<HomeDrawerState>();
  final GlobalKey firstPaymentItemKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final handlers = <Handler>[];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      handlers.addAll([
        InputHandler(
          firstPaymentItemKey,
          _scaffoldKey,
        ),
        ConnectivityHandler(),
        PaymentResultHandler(),
        HealthCheckHandler(),
      ]);
      for (var handler in handlers) {
        handler.init(this);
      }
      checkVersionDialog(context, context.read());
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (var handler in handlers) {
      handler.dispose();
    }
    handlers.clear();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final mediaSize = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        // Only close drawer if it's open
        final NavigatorState navigator = Navigator.of(context);
        if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
          navigator.pop();
          return;
        }

        // If drawer is not open, prompt user to approve exiting the app
        final texts = context.texts();
        final bool? shouldPop = await promptAreYouSure(
          context,
          texts.close_popup_title,
          Text(texts.close_popup_message),
        );
        if (shouldPop ?? false) {
          exit(0);
        }
      },
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

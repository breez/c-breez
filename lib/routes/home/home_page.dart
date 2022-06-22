import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/handlers/check_version_handler.dart';
import 'package:c_breez/handlers/received_invoice_notification.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/clipboard.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/routes/home/account_page.dart';
import 'package:c_breez/routes/home/widgets/app_bar/home_app_bar.dart';
import 'package:c_breez/routes/home/widgets/bottom_actions_bar/bottom_actions_bar.dart';
import 'package:c_breez/routes/home/widgets/close_popup.dart';
import 'package:c_breez/routes/home/widgets/drawer/home_drawer.dart';
import 'package:c_breez/routes/home/widgets/fade_in_widget.dart';
import 'package:c_breez/routes/home/widgets/qr_action_button.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final GlobalKey podcastMenuItemKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<HomeDrawerState> _drawerKey = GlobalKey<HomeDrawerState>();
  final GlobalKey firstPaymentItemKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  bool _listensInit = false;

  @override
  Widget build(BuildContext context) {
    _initListens(context);
    final texts = context.texts();

    return WillPopScope(
      onWillPop: willPopCallback(
        context,
        canCancel: () => _scaffoldKey.currentState?.isDrawerOpen ?? false,
      ),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, userState) {
          final user = userState.profileSettings;
          return BlocBuilder<AccountBloc, AccountState>(
            builder: (context, account) {
              return BlocBuilder<LSPBloc, LSPState>(
                builder: (context, lspState) {
                  return StreamBuilder<DecodedClipboardData>(
                    stream: context.read<InputBloc>().decodedClipboardStream,
                    builder: (context, snapshot) {
                      return _build(
                        context,
                        user,
                        account,
                        lspState,
                        texts,
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _build(
    BuildContext context,
    UserProfileSettings user,
    AccountState account,
    LSPState lspStatus,
    AppLocalizations texts,
  ) {
    final themeData = Theme.of(context);
    final mediaSize = MediaQuery.of(context).size;

    return SizedBox(
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
          drawer: Theme(
            data: theme.themeMap[user.themeId] ?? themeData,
            child: HomeDrawer(
              key: _drawerKey,
            ),
          ),
          bottomNavigationBar: BottomActionsBar(account, firstPaymentItemKey),
          floatingActionButton: QrActionButton(account, firstPaymentItemKey),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: _drawerKey.currentState?.screen() ??
              AccountPage(
                firstPaymentItemKey,
                scrollController,
              ),
        ),
      ),
    );
  }

  void _initListens(BuildContext context) {
    if (_listensInit) return;
    _listensInit = true;

    InvoiceNotificationsHandler(
      context,
      firstPaymentItemKey,
      scrollController,
      _scaffoldKey,
    );

    checkVersionDialog(context, context.read());
  }
}

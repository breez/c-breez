import 'dart:async';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/routes/home/bottom_actions_bar.dart';
import 'package:c_breez/routes/home/qr_action_button.dart';
import 'package:c_breez/theme_data.dart' as theme;
import 'package:c_breez/widgets/close_popup.dart';
import 'package:c_breez/widgets/fade_in_widget.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/navigation_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'bloc/account/account_state.dart';
import 'models/invoice.dart';
import 'handlers/check_version_handler.dart';
import 'handlers/received_invoice_notification.dart';
import 'routes/account_required_actions.dart';
import 'routes/home/account_page.dart';

final GlobalKey firstPaymentItemKey = GlobalKey();
final ScrollController scrollController = ScrollController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  final AccountBloc accountBloc;
  final InvoiceBloc invoiceBloc;
  final UserProfileBloc userProfileBloc;
  final LSPBloc lspBloc;

  Home(
    this.accountBloc,
    this.invoiceBloc,
    this.userProfileBloc,
    this.lspBloc,
  );

  final List<DrawerItemConfig> _screens = List<DrawerItemConfig>.unmodifiable([
    const DrawerItemConfig("breezHome", "Breez", ""),
  ]);

  final Map<String, Widget> _screenBuilders = {};

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with WidgetsBindingObserver {
  final GlobalKey podcastMenuItemKey = GlobalKey();
  String _activeScreen = "breezHome";
  final Set _hiddenRoutes = <String>{};
  StreamSubscription<String>? _accountNotificationsSubscription;
  bool _listensInit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    widget.accountBloc.stream.listen((acc) {
      var activeAccountRoutes = ["/connect_to_pay", "/pay_invoice", "/create_invoice"];
      Function addOrRemove = acc.status == AccountStatus.CONNECTED ? _hiddenRoutes.remove : _hiddenRoutes.add;
      setState(() {
        for (var r in activeAccountRoutes) {
          addOrRemove(r);
        }
      });
    });
  }

  void _initListens(BuildContext context) {
    if (_listensInit) return;
    _listensInit = true;
    _registerNotificationHandlers(context);    
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _accountNotificationsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initListens(context);    
    final texts = AppLocalizations.of(context)!;

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
                    stream: widget.invoiceBloc.decodedClipboardStream,
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
          appBar: AppBar(            
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: AccountRequiredActionsIndicator(                  
                  widget.lspBloc,
                ),
              ),
            ],
            leading: _buildMenuIcon(context, "hamburger"),
            title: IconButton(
              padding: EdgeInsets.zero,
              icon: SvgPicture.asset(
                "src/images/logo-color.svg",
                height: 23.5,
                width: 62.7,
                color: themeData.appBarTheme.actionsIconTheme?.color,
                colorBlendMode: BlendMode.srcATop,
              ),
              iconSize: 64,
              onPressed: () async {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 0, 133, 251),
            ),
            backgroundColor: theme.customData[theme.themeId]!.dashboardBgColor,
            elevation: 0.0,
          ),
          drawerEnableOpenDragGesture: true,
          drawerDragStartBehavior: DragStartBehavior.down,
          drawerEdgeDragWidth: mediaSize.width,
          drawer: Theme(
            data: theme.themeMap[user.themeId]!,
            child: _navigationDrawer(
              context,
              user,
              account,
              lspStatus,
              texts,
            ),
          ),
          bottomNavigationBar: BottomActionsBar(account, firstPaymentItemKey),
          floatingActionButton: QrActionButton(account, firstPaymentItemKey),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: widget._screenBuilders[_activeScreen] ??
              _homePage(
                context,
                user,
              ),
        ),
      ),
    );
  }

  NavigationDrawer _navigationDrawer(
    BuildContext context,
    UserProfileSettings user,
    AccountState account,
    LSPState lspStatus,
    AppLocalizations texts,
  ) {
    return NavigationDrawer(
      true,
      [        
        DrawerItemConfigGroup(
          _filterItems(_drawerConfigToFilter(context, user, texts)),
          groupTitle: texts.home_drawer_item_title_preferences,
          groupAssetImage: "",
        ),
      ],
      _onNavigationItemSelected,
    );
  }

  List<DrawerItemConfig> _drawerConfigToFilter(
    BuildContext context,
    UserProfileSettings user,
    AppLocalizations texts,
  ) {
    return [
      DrawerItemConfig(
        "/fiat_currency",
        texts.home_drawer_item_title_fiat_currencies,
        "src/icon/fiat_currencies.png",
      ),
      ..._drawerConfigAdvancedFlavorItems(context, user, texts),
    ];
  }

  List<DrawerItemConfig> _drawerConfigAdvancedFlavorItems(
    BuildContext context,
    UserProfileSettings user,
    AppLocalizations texts,
  ) {
    return [
      DrawerItemConfig(
        "/developers",
        texts.home_drawer_item_title_developers,
        "src/icon/developers.png",
      ),
    ];
  }

  IconButton _buildMenuIcon(BuildContext context, String assetName) {
    final themeData = Theme.of(context);

    return IconButton(
      icon: Image.asset(
        "src/icon/$assetName.png",
        height: 24.0,
        width: 24.0,
        color: themeData.appBarTheme.actionsIconTheme?.color,
      ),
      onPressed: () {
        _scaffoldKey.currentState!.openDrawer();
      },
    );
  }

  Widget _homePage(BuildContext context, UserProfileSettings user) {
    return AccountPage(firstPaymentItemKey, scrollController);
  }

  _onNavigationItemSelected(String itemName) {
    if (widget._screens.map((sc) => sc.name).contains(itemName)) {
      setState(() {
        _activeScreen = itemName;
      });
    } else {
      Navigator.of(context).pushNamed(itemName).then((message) {
        if (message != null && message.runtimeType == String) {
          showFlushbar(context, message: message as String);
        }
      });
    }
  }

  void _registerNotificationHandlers(BuildContext context) {
    InvoiceNotificationsHandler(
      context,      
      widget.accountBloc,
      widget.invoiceBloc,
      firstPaymentItemKey,
      scrollController,
      _scaffoldKey,
    );

    checkVersionDialog(context, widget.userProfileBloc);
  }

  List<DrawerItemConfig> _filterItems(List<DrawerItemConfig> items) {
    return items.where((c) => !_hiddenRoutes.contains(c.name)).toList();
  }

  DrawerItemConfig get activeScreen {
    return widget._screens.firstWhere((screen) => screen.name == _activeScreen);
  }
}

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_settings.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'breez_navigation_drawer.dart';

const _kActiveAccountRoutes = ["/connect_to_pay", "/pay_invoice", "/create_invoice"];

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  final Set<String> _hiddenRoutes = {};
  final List<DrawerItemConfig> _screens = [const DrawerItemConfig("breezHome", "Breez Cloud", "")];
  final Map<String, Widget> _screenBuilders = {};

  String _activeScreen = "breezHome";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, user) {
        final settings = user.profileSettings;
        return BlocBuilder<LSPBloc, LspState?>(
          builder: (context, lspState) {
            final addOrRemove = (lspState?.lspInfo != null) ? _hiddenRoutes.remove : _hiddenRoutes.add;
            for (var route in _kActiveAccountRoutes) {
              addOrRemove(route);
            }
            return BlocBuilder<RefundBloc, RefundState>(
              builder: (context, refundState) {
                return _build(context, settings, refundState.refundables);
              },
            );
          },
        );
      },
    );
  }

  Widget _build(BuildContext context, UserProfileSettings settings, List<SwapInfo>? refundables) {
    final texts = context.texts();

    return BreezNavigationDrawer(
      [
        ..._drawerConfigAppModeItems(context, settings),
        if (refundables != null && refundables.isNotEmpty) ...[
          DrawerItemConfigGroup([
            DrawerItemConfig(
              "/get_refund",
              texts.home_drawer_item_title_get_refund,
              "src/icon/withdraw_funds.png",
            ),
          ]),
        ],
        DrawerItemConfigGroup(
          _filterItems(_drawerConfigToFilter(context)),
          groupTitle: texts.home_drawer_item_title_preferences,
          groupAssetImage: "",
          isExpanded: settings.expandPreferences,
        ),
      ],
      (screenName) {
        if (_screens.map((sc) => sc.name).contains(screenName)) {
          setState(() {
            _activeScreen = screenName;
          });
        } else {
          Navigator.of(context).pushNamed(screenName).then((message) {
            if (message != null && message is String && context.mounted) {
              showFlushbar(context, message: message);
            }
          });
        }
      },
    );
  }

  List<DrawerItemConfigGroup> _drawerConfigAppModeItems(BuildContext context, UserProfileSettings user) {
    return [
      DrawerItemConfigGroup([
        _drawerItemBalance(context, user),
        // App are disabled untill we support it ref:
        // (https://github.com/breez/c-breez/issues/388#issue-1551748496)
        //_drawerItemLightningApps(context, user),
      ]),
    ];
  }

  DrawerItemConfig _drawerItemBalance(BuildContext context, UserProfileSettings user) {
    final texts = context.texts();
    return DrawerItemConfig(
      "",
      texts.home_drawer_item_title_balance,
      "src/icon/balance.png",
      isSelected: user.appMode == AppMode.balance,
      onItemSelected: (_) {
        // TODO add protectAdminAction
      },
    );
  }

  List<DrawerItemConfig> _drawerConfigToFilter(BuildContext context) {
    final texts = context.texts();
    return [
      DrawerItemConfig(
        "/fiat_currency",
        texts.home_drawer_item_title_fiat_currencies,
        "src/icon/fiat_currencies.png",
      ),
      DrawerItemConfig("/network", texts.home_drawer_item_title_network, "src/icon/network.png"),
      DrawerItemConfig(
        "/security",
        texts.home_drawer_item_title_security_and_backup,
        "src/icon/security.png",
      ),
      DrawerItemConfig(
        "/payment_options",
        texts.home_drawer_item_title_payment_options,
        "src/icon/payment_options.png",
      ),
      ..._drawerConfigAdvancedFlavorItems(context),
    ];
  }

  List<DrawerItemConfig> _drawerConfigAdvancedFlavorItems(BuildContext context) {
    final texts = context.texts();
    return [
      DrawerItemConfig("/developers", texts.home_drawer_item_title_developers, "src/icon/developers.png"),
    ];
  }

  List<DrawerItemConfig> _filterItems(List<DrawerItemConfig> items) {
    return items.where((c) => !_hiddenRoutes.contains(c.name)).toList();
  }

  Widget? screen() {
    return _screenBuilders[_activeScreen];
  }
}

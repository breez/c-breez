import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kActiveAccountRoutes = [
  "/connect_to_pay",
  "/pay_invoice",
  "/create_invoice",
];

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeDrawer> createState() => HomeDrawerState();
}

class HomeDrawerState extends State<HomeDrawer> {
  final Set<String> _hiddenRoutes = {};
  final List<DrawerItemConfig> _screens = [
    const DrawerItemConfig("breezHome", "Breez", ""),
  ];
  final Map<String, Widget> _screenBuilders = {};

  String _activeScreen = "breezHome";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, user) {
        final settings = user.profileSettings;
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, account) {
            final addOrRemove = account.status == AccountStatus.CONNECTED
                ? _hiddenRoutes.remove
                : _hiddenRoutes.add;
            for (var route in _kActiveAccountRoutes) {
              addOrRemove(route);
            }

            return _build(context, settings);
          },
        );
      },
    );
  }

  Widget _build(
    BuildContext context,
    UserProfileSettings settings,
  ) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Theme(
      data: theme.themeMap[settings.themeId] ?? themeData,
      child: NavigationDrawer(
        [
          DrawerItemConfigGroup(
            _filterItems(_drawerConfigToFilter(context)),
            groupTitle: texts.home_drawer_item_title_preferences,
            groupAssetImage: "",
          ),
        ],
        (screenName) {
          if (_screens.map((sc) => sc.name).contains(screenName)) {
            setState(() {
              _activeScreen = screenName;
            });
          } else {
            Navigator.of(context).pushNamed(screenName).then((message) {
              if (message != null && message is String) {
                showFlushbar(context, message: message);
              }
            });
          }
        },
      ),
    );
  }

  List<DrawerItemConfig> _drawerConfigToFilter(
    BuildContext context,
  ) {
    final texts = context.texts();
    return [
      DrawerItemConfig(
        "/fiat_currency",
        texts.home_drawer_item_title_fiat_currencies,
        "src/icon/fiat_currencies.png",
      ),
      ..._drawerConfigAdvancedFlavorItems(context),
    ];
  }

  List<DrawerItemConfig> _drawerConfigAdvancedFlavorItems(
    BuildContext context,
  ) {
    final texts = context.texts();
    return [
      DrawerItemConfig(
        "/developers",
        texts.home_drawer_item_title_developers,
        "src/icon/developers.png",
      ),
    ];
  }

  List<DrawerItemConfig> _filterItems(
    List<DrawerItemConfig> items,
  ) {
    return items.where((c) => !_hiddenRoutes.contains(c.name)).toList();
  }

  Widget? screen() {
    return _screenBuilders[_activeScreen];
  }
}

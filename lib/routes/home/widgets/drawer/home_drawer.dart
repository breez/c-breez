import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/refund/refund_bloc.dart';
import 'package:c_breez/bloc/refund/refund_state.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/models/user_profile.dart';
import 'package:c_breez/routes/home/widgets/drawer/breez_navigation_drawer.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_group.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_item.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return BlocBuilder2<UserProfileBloc, UserProfileState, RefundBloc, RefundState>(
      builder: (context, user, refundState) {
        final settings = user.profileSettings;
        final refundables = refundState.refundables;

        return BreezNavigationDrawer(
          [
            DrawerGroup(
              items: [
                DrawerItem(
                  title: texts.home_drawer_item_title_balance,
                  icon: "src/icon/balance.png",
                  isSelected: settings.appMode == AppMode.balance,
                ),
              ],
            ),
            if (refundables != null && refundables.isNotEmpty)
              DrawerGroup(
                items: [
                  DrawerItem(
                    route: "/get_refund",
                    title: texts.home_drawer_item_title_get_refund,
                    icon: "src/icon/withdraw_funds.png",
                  ),
                ],
              ),
            DrawerGroup(
              groupTitle: texts.home_drawer_item_title_preferences,
              groupAssetImage: "",
              isExpanded: settings.expandPreferences,
              items: [
                DrawerItem(
                  route: "/fiat_currency",
                  title: texts.home_drawer_item_title_fiat_currencies,
                  icon: "src/icon/fiat_currencies.png",
                ),
                DrawerItem(
                  route: "/network",
                  title: texts.home_drawer_item_title_network,
                  icon: "src/icon/network.png",
                ),
                DrawerItem(
                  route: "/security",
                  title: texts.home_drawer_item_title_security_and_backup,
                  icon: "src/icon/security.png",
                ),
                DrawerItem(
                  route: "/payment_options",
                  title: texts.home_drawer_item_title_payment_options,
                  icon: "src/icon/payment_options.png",
                ),
                DrawerItem(
                  route: "/developers",
                  title: texts.home_drawer_item_title_developers,
                  icon: "src/icon/developers.png",
                ),
              ],
            ),
          ],
          (screenName) {
            Navigator.of(context).pushNamed(screenName).then((message) {
              if (message != null && message is String) {
                showFlushbar(context, message: message);
              }
            });
          },
        );
      },
    );
  }
}

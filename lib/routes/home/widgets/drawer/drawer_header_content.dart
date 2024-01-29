import 'package:auto_size_text/auto_size_text.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/home/widgets/drawer/breez_avatar_dialog.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_theme_switch.dart';
import 'package:c_breez/theme/theme_extensions.dart';
import 'package:c_breez/widgets/breez_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerHeaderContent extends StatelessWidget {
  const DrawerHeaderContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    return BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, userSettings) {
      final profileSettings = userSettings.profileSettings;

      return GestureDetector(
        onTap: () {
          showDialog<bool>(
            useRootNavigator: false,
            context: context,
            barrierDismissible: false,
            builder: (context) => BreezAvatarDialog(),
          );
        },
        child: Column(children: [
          const DrawerThemeSwitch(),
          Row(
            children: [
              BreezAvatar(profileSettings.avatarURL, radius: 24.0),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AutoSizeText(
                  profileSettings.name ?? texts.home_drawer_error_no_name,
                  style: navigationDrawerHandleStyle,
                ),
              ),
            ],
          ),
        ]),
      );
    });
  }
}

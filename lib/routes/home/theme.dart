import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/theme_data.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget withBreezTheme(BuildContext context, Widget child) {
  return BlocBuilder<UserProfileBloc, UserProfileState>(
    builder: (context, userState) {
      var currentTheme = theme.themeMap[userState.profileSettings.themeId];
      return Theme(child: child, data: currentTheme!);
    },
  );
}

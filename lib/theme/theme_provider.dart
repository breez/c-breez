import 'package:flutter/material.dart';

import 'breez_dark_theme.dart';
import 'breez_light_theme.dart';

export 'breez_colors.dart';
export 'breez_dark_theme.dart';
export 'breez_light_theme.dart';
export 'custom_theme_data.dart';
export 'theme_extensions.dart';
export 'vendor_theme.dart';

String themeId = "BLUE";

final Map<String, ThemeData> themeMap = {
  "BLUE": breezLightTheme,
  "DARK": breezDarkTheme
};

ThemeData get calendarTheme =>
    themeId == "BLUE" ? calendarLightTheme : calendarDarkTheme;

import 'package:c_breez/theme/breez_dark_theme.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:flutter/material.dart';

export 'breez_colors.dart';
export 'custom_theme_data.dart';
export 'theme_extensions.dart';
export 'vendor_theme.dart';

String themeId = "BLUE";

final Map<String, ThemeData> themeMap = {
  "BLUE": breezLightTheme,
  "DARK": breezDarkTheme
};
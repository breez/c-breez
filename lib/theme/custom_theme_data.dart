import 'package:flutter/material.dart';

import 'breez_colors.dart';

class CustomData {
  BlendMode loaderColorBlendMode;
  String loaderAssetPath;
  Color pendingTextColor;
  Color dashboardBgColor;
  Color paymentListBgColor;
  Color paymentListBgColorLight;
  Color navigationDrawerHeaderBgColor;
  Color surfaceBgColor;

  CustomData({
    required this.loaderColorBlendMode,
    required this.loaderAssetPath,
    required this.pendingTextColor,
    required this.dashboardBgColor,
    required this.paymentListBgColor,
    required this.paymentListBgColorLight,
    required this.navigationDrawerHeaderBgColor,
    required this.surfaceBgColor,
  });
}

final CustomData blueThemeCustomData = CustomData(
  loaderColorBlendMode: BlendMode.multiply,
  loaderAssetPath: 'src/images/breez_loader_blue.gif',
  dashboardBgColor: Colors.white,
  pendingTextColor: const Color(0xff4D88EC),
  paymentListBgColor: const Color(0xFFf9f9f9),
  paymentListBgColorLight: Colors.white,
  navigationDrawerHeaderBgColor: const Color.fromRGBO(0, 103, 255, 1),
  surfaceBgColor: BreezColors.blue[500]!,
);

final CustomData darkThemeCustomData = CustomData(
  loaderColorBlendMode: BlendMode.multiply,
  loaderAssetPath: 'src/images/breez_loader_dark.gif',
  pendingTextColor: const Color(0xff4D88EC),
  dashboardBgColor: const Color(0xFF00091c),
  paymentListBgColor: const Color.fromRGBO(10, 20, 40, 1),
  paymentListBgColorLight: const Color.fromRGBO(10, 20, 40, 1.33),
  navigationDrawerHeaderBgColor: const Color(0xFF00091c),
  surfaceBgColor: const Color.fromRGBO(10, 20, 40, 1),
);

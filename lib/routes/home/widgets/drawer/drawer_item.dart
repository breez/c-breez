import 'package:flutter/material.dart';

class DrawerItem {
  final GlobalKey? key;
  final String? route;
  final String title;
  final String icon;
  final bool disabled;
  final void Function(String name)? onItemSelected;
  final Widget? switchWidget;
  final bool isSelected;

  const DrawerItem({
    this.route,
    this.title = "",
    required this.icon,
    this.key,
    this.onItemSelected,
    this.disabled = false,
    this.switchWidget,
    this.isSelected = false,
  });
}

import 'dart:async';

import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_state.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_group.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_header_container.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_header_content.dart';
import 'package:c_breez/routes/home/widgets/drawer/drawer_item.dart';
import 'package:c_breez/routes/home/widgets/drawer/navigation_drawer_footer.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreezNavigationDrawer extends StatelessWidget {
  final List<DrawerGroup> _drawerGroupedItems;
  final void Function(String screenName) _onItemSelected;
  final _scrollController = ScrollController();

  BreezNavigationDrawer(
    this._drawerGroupedItems,
    this._onItemSelected, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, userSettings) {
      return Theme(
        data: themeData.copyWith(
          canvasColor: themeData.customData.navigationDrawerBgColor,
        ),
        child: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(0.0),
                  children: [
                    Container(
                      color: Theme.of(context).customData.navigationDrawerHeaderBgColor,
                      child: const DrawerHeaderContainer(
                        padding: EdgeInsets.only(left: 16.0),
                        child: DrawerHeaderContent(),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16)),
                    ..._drawerGroupedItems
                        .map((groupItems) => _createDrawerGroupWidgets(
                              groupItems,
                              context,
                              _drawerGroupedItems.indexOf(groupItems),
                              withDivider: groupItems.withDivider,
                            ))
                        .expand((element) => element),
                  ],
                ),
              ),
              const NavigationDrawerFooter(),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _createDrawerGroupWidgets(
    DrawerGroup group,
    BuildContext context,
    int index, {
    bool withDivider = false,
  }) {
    List<Widget> groupItems = group.items
        .map((action) => _actionTile(
              action,
              context,
              action.onItemSelected ?? _onItemSelected,
            ))
        .toList();
    if (group.groupTitle != null && groupItems.isNotEmpty) {
      groupItems = group.items
          .map((action) => _actionTile(
                action,
                context,
                action.onItemSelected ?? _onItemSelected,
                subTile: true,
              ))
          .toList();
      groupItems = [
        _ExpansionTile(
          items: groupItems,
          title: group.groupTitle ?? "",
          icon: group.groupAssetImage == null ? null : AssetImage(group.groupAssetImage!),
          controller: _scrollController,
          isExpanded: group.isExpanded,
        )
      ];
    }

    if (groupItems.isNotEmpty && withDivider && index != 0) {
      groupItems.insert(0, _ListDivider());
    }
    return groupItems;
  }
}

class _ListDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(),
    );
  }
}

Widget _actionTile(
  DrawerItem action,
  BuildContext context,
  Function onItemSelected, {
  bool? subTile,
}) {
  final themeData = Theme.of(context);
  TextStyle itemStyle = theme.drawerItemTextStyle;

  Color? color;
  if (action.disabled) {
    color = themeData.disabledColor;
    itemStyle = itemStyle.copyWith(color: color);
  }
  return Padding(
    padding: EdgeInsets.only(
      left: 0.0,
      right: subTile != null ? 0.0 : 16.0,
    ),
    child: Ink(
      decoration: subTile != null
          ? null
          : BoxDecoration(
              color: action.isSelected ? themeData.primaryColorLight : Colors.transparent,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(32),
              ),
            ),
      child: ListTile(
        key: action.key,
        shape: subTile != null
            ? null
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(32),
                ),
              ),
        leading: Padding(
          padding: subTile != null
              ? const EdgeInsets.only(left: 28.0)
              : const EdgeInsets.symmetric(horizontal: 8.0),
          child: ImageIcon(
            AssetImage(action.icon),
            size: 26.0,
            color: color,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            action.title,
            style: itemStyle,
          ),
        ),
        trailing: action.switchWidget,
        onTap: action.disabled
            ? null
            : () {
                Navigator.pop(context);
                onItemSelected(action.route);
              },
      ),
    ),
  );
}

class _ExpansionTile extends StatelessWidget {
  final List<Widget> items;
  final String title;
  final AssetImage? icon;
  final ScrollController controller;
  final bool isExpanded;

  const _ExpansionTile({
    required this.items,
    required this.title,
    required this.icon,
    required this.controller,
    this.isExpanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final expansionTileTheme = themeData.copyWith(
      dividerColor: themeData.canvasColor,
    );
    return Theme(
      data: expansionTileTheme,
      child: ExpansionTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: (icon?.assetName ?? "") == ""
              ? null
              : Text(
                  title,
                  style: theme.drawerItemTextStyle,
                ),
        ),
        initiallyExpanded: isExpanded,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: (icon?.assetName ?? "") == ""
              ? Text(
                  title,
                  style: theme.drawerItemTextStyle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                )
              : ImageIcon(
                  icon,
                  size: 26.0,
                  color: Colors.white,
                ),
        ),
        children: items
            .map((item) => Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: item,
                ))
            .toList(),
        onExpansionChanged: (isExpanded) {
          context.read<UserProfileBloc>().updateProfile(expandPreferences: isExpanded);
          if (isExpanded) {
            Timer(
              const Duration(milliseconds: 200),
              () => controller.animateTo(
                controller.position.maxScrollExtent + 28.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.ease,
              ),
            );
          }
          // 28 = bottom padding of list + intrinsic bottom padding
        },
      ),
    );
  }
}

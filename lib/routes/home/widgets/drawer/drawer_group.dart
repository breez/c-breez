import 'package:c_breez/routes/home/widgets/drawer/drawer_item.dart';

class DrawerGroup {
  final List<DrawerItem> items;
  final String? groupTitle;
  final String? groupAssetImage;
  final bool withDivider;
  final bool isExpanded;

  const DrawerGroup({
    this.groupTitle,
    this.groupAssetImage,
    this.withDivider = true,
    this.isExpanded = true,
    this.items = const [],
  });
}

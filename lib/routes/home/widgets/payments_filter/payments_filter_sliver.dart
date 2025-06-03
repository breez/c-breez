import 'package:c_breez/routes/home/widgets/payments_filter/fixed_sliver_delegate.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';

class PaymentsFilterSliver extends StatefulWidget {
  final double maxSize;
  final bool hasFilter;
  final ScrollController scrollController;

  const PaymentsFilterSliver({
    super.key,
    required this.maxSize,
    required this.hasFilter,
    required this.scrollController,
  });

  @override
  State<PaymentsFilterSliver> createState() => _PaymentsFilterSliverState();
}

class _PaymentsFilterSliverState extends State<PaymentsFilterSliver> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(onScroll);
    super.dispose();
  }

  void onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final scrollOffset = widget.scrollController.position.pixels;

    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedSliverDelegate(
        widget.hasFilter ? widget.maxSize : scrollOffset.clamp(0, widget.maxSize),
        builder: (context, height, overlapContent) {
          return Container(
            color: themeData.isLightTheme ? themeData.colorScheme.surface : themeData.canvasColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: themeData.customData.paymentListBgColor,
                  height: widget.maxSize,
                  child: const PaymentsFilters(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

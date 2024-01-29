import 'package:flutter/material.dart';

class NavigationDrawerFooter extends StatelessWidget {
  const NavigationDrawerFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kBreezBottomSheetHeight + 8.0 + MediaQuery.of(context).viewPadding.bottom,
      child: Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "src/images/drawer_footer.png",
                height: 39,
                width: 183,
                fit: BoxFit.fitHeight,
              )
            ],
          ),
        ],
      ),
    );
  }
}

const double _kBreezBottomSheetHeight = 60.0;

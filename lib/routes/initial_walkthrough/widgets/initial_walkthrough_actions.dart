import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/routes/initial_walkthrough/services/initial_walkthrough_service.dart';
import 'package:c_breez/routes/initial_walkthrough/widgets/register_button.dart';
import 'package:c_breez/routes/initial_walkthrough/widgets/restore_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

class InitialWalkthroughActions extends StatelessWidget {
  const InitialWalkthroughActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<InitialWalkthroughService>(
      create: (BuildContext context) => InitialWalkthroughService(context),
      lazy: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RegisterButton(autoSizeGroup: _autoSizeGroup),
          const SizedBox(height: 24),
          RestoreButton(autoSizeGroup: _autoSizeGroup),
        ],
      ),
    );
  }
}

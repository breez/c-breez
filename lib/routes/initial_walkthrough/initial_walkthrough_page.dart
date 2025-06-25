import 'package:c_breez/routes/home/widgets/drawer/breez_navigation_drawer.dart';
import 'package:c_breez/routes/initial_walkthrough/widgets/animated_logo.dart' show AnimatedLogo;
import 'package:c_breez/routes/initial_walkthrough/widgets/initial_walkthrough_actions.dart'
    show InitialWalkthroughActions;
import 'package:c_breez/services/wallet_archive_service.dart';
import 'package:c_breez/theme/breez_colors.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';
import 'package:theme_provider/theme_provider.dart';

final Logger _logger = Logger('InitialWalkthroughPage');

class InitialWalkthroughPage extends StatefulWidget {
  static const String routeName = '/intro';

  const InitialWalkthroughPage({super.key});

  @override
  State createState() => InitialWalkthroughPageState();
}

class InitialWalkthroughPageState extends State<InitialWalkthroughPage> {
  final OverlayManager _overlayManager = OverlayManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ThemeController themeProvider = ThemeProvider.controllerOf(context);
      themeProvider.setTheme('light');
    });
  }

  @override
  void dispose() {
    _overlayManager.removeLoadingOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: themeData.appBarTheme.systemOverlayStyle!.copyWith(
        systemNavigationBarColor: BreezColors.blue[500],
      ),
      child: Theme(
        data: breezLightTheme,
        child: Scaffold(
          appBar: AppBar(
            actionsPadding: EdgeInsets.only(right: 16, top: 16),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                tooltip: 'Share Logs',
                onPressed: _shareLogs,
              ),
            ],
          ),
          body: const SafeArea(
            child: Column(
              children: <Widget>[
                Spacer(flex: 3),
                AnimatedLogo(),
                Spacer(flex: 3),
                InitialWalkthroughActions(),
                Spacer(),
                NavigationDrawerFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Share application logs
  Future<void> _shareLogs() async {
    _overlayManager.showLoadingOverlay(context);

    try {
      final String zipPath = await WalletArchiveService.createLogsArchive();
      final ShareParams shareParams = ShareParams(title: 'Logs', files: <XFile>[XFile(zipPath)]);
      SharePlus.instance.share(shareParams);
    } catch (e) {
      _logger.severe('Failed to share logs: $e');

      if (mounted) {
        showFlushbar(context, message: 'Failed to share logs: ${e.toString()}');
      }
    } finally {
      _overlayManager.removeLoadingOverlay();
    }
  }
}

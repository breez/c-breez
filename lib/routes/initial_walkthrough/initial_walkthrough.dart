import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'beta_warning_dialog.dart';
import 'mnemonics/enter_mnemonic_seed_page.dart';

class InitialWalkthroughPage extends StatefulWidget {
  @override
  State createState() => InitialWalkthroughPageState();
}

class InitialWalkthroughPageState extends State<InitialWalkthroughPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _controller;
  Animation<int>? _animation;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2720),
    )..forward(from: 0.0);
    _animation = IntTween(begin: 0, end: 67).animate(_controller!);
    if (_controller!.isCompleted) {
      _controller!.stop();
      _controller!.dispose();
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 200,
                  child: Container(),
                ),
                Expanded(
                  flex: 171,
                  child: AnimatedBuilder(
                    animation: _animation!,
                    builder: (BuildContext context, Widget? child) {
                      String frame =
                          _animation!.value.toString().padLeft(2, '0');
                      return Image.asset(
                        'src/animations/welcome/frame_${frame}_delay-0.04s.png',
                        gaplessPlayback: true,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 200,
                  child: Container(),
                ),
                Expanded(
                  flex: 48,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: AutoSizeText(
                      texts.initial_walk_through_welcome_message,
                      textAlign: TextAlign.center,
                      style: theme.welcomeTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 60,
                  child: Container(),
                ),
                SizedBox(
                  height: 48.0,
                  width: 168.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      primary: themeData.primaryColor,
                      elevation: 0.0,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      texts.initial_walk_through_lets_breeze,
                      style: themeData.textTheme.button,
                    ),
                    onPressed: () => _letsBreez(context),
                  ),
                ),
                Expanded(
                  flex: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: GestureDetector(
                      onTap: () => _restoreFromBackup(context),
                      child: Text(
                        texts.initial_walk_through_restore_from_backup,
                        style: theme.restoreLinkStyle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 120,
                  child: Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _letsBreez(BuildContext context) async {
    bool approved = await showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BetaWarningDialog();
      },
    );
    if (approved) _generateMnemonicSeed();
  }

  void _generateMnemonicSeed() async {
    Navigator.of(context).pushNamed("/mnemonics");
  }

  void _restoreFromBackup(BuildContext context) {
    Navigator.of(context).pushNamed("/restore");
  }
}

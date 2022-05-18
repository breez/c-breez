import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/user_profile/user_profile_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
//import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bip39/bip39.dart' as bip39;

import 'beta_warning_dialog.dart';

class InitialWalkthroughPage extends StatefulWidget {
  final UserProfileBloc _registrationBloc;
  final AccountBloc _accountBloc;

  const InitialWalkthroughPage(this._registrationBloc, this._accountBloc);

  @override
  State createState() => InitialWalkthroughPageState();
}

class InitialWalkthroughPageState extends State<InitialWalkthroughPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? _controller;
  Animation<int>? _animation;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _registered = false;

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

  void _proceedToRegister() async {
    await widget._registrationBloc.registerForNotifications();
    _registered = true;
    var seed = bip39.mnemonicToSeed(bip39.generateMnemonic());
    var range = seed.getRange(0, 32);
    var list = Uint8List.fromList(range.toList());
    await widget._accountBloc.startNewNode(list);
    Navigator.of(context).pushReplacementNamed("/");
  }

  Future<bool> _onWillPop() async {
    if (!_registered) {
      exit(0);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: Padding(
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
      ),
    );
  }

  void _letsBreez(BuildContext context) {
    final texts = AppLocalizations.of(context);
    final themeData = Theme.of(context);

    showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BetaWarningDialog();
      },
    ).then((approved) {
      if (approved) {
        return _proceedToRegister();
      }
    });
  }

  void _restoreFromBackup(BuildContext context) {}
}

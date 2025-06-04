import 'dart:async';

import 'package:c_breez/routes/initial_walkthrough/initial_walkthrough_page.dart';
import 'package:c_breez/theme/breez_light_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = 'splash';

  const SplashPage();

  @override
  SplashPageState createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3600), () {
      Navigator.of(context).pushReplacementNamed(InitialWalkthroughPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: themeData.appBarTheme.systemOverlayStyle!,
      child: Theme(
        data: breezLightTheme,
        child: Scaffold(
          body: Center(
            child: Image.asset(
              'src/images/splash-animation.gif',
              fit: BoxFit.contain,
              gaplessPlayback: true,
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
        ),
      ),
    );
  }
}

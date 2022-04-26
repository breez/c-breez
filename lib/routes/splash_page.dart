import 'dart:async';
import 'package:c_breez/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  final UserProfileSettings _user;

  const SplashPage(this._user);

  @override
  SplashPageState createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkIfFirstRun();
  }

  Future checkIfFirstRun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isFirstRun = (prefs.getBool('isFirstRun') ?? true);
    if (widget._user.registered == false ||
        _isFirstRun) {
      prefs.setBool('isFirstRun', false);
      _startTime();
    } else {
      prefs.setBool('isFirstRun', true);
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  _startTime() async {
    return Timer(const Duration(milliseconds: 3600), () {
      Navigator.of(context).pushReplacementNamed('/intro');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Center(
        child: Image.asset(
          'src/images/splash-animation.gif',
          fit: BoxFit.contain,
          gaplessPlayback: true,
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),
    ]));
  }
}

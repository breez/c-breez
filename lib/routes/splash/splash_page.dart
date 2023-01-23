import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SplashPage extends StatefulWidget {
  final bool isInitial;
  const SplashPage({required this.isInitial});

  @override
  SplashPageState createState() {
    return SplashPageState();
  }
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (widget.isInitial) {
      Timer(const Duration(milliseconds: 3600), () {
        Navigator.of(context).pushReplacementNamed('/intro');
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (widget.isInitial)
          ? Center(
              child: Image.asset(
                'src/images/splash-animation.gif',
                fit: BoxFit.contain,
                gaplessPlayback: true,
                width: MediaQuery.of(context).size.width / 3,
              ),
            )
          : const SizedBox(),
    );
  }
}

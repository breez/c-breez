import 'dart:async';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
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
    var accBloc = context.read<AccountBloc>();
    if (accBloc.state.initial) {
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
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, accountState) {
          if (accountState.initial) {
            return Center(
              child: Image.asset(
                'src/images/splash-animation.gif',
                fit: BoxFit.contain,
                gaplessPlayback: true,
                width: MediaQuery.of(context).size.width / 3,
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

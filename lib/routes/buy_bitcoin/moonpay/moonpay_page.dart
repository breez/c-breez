import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_bloc.dart';
import 'package:c_breez/bloc/buy_bitcoin/moonpay/moonpay_state.dart';
import 'package:c_breez/routes/buy_bitcoin/moonpay/moonpay_loading.dart';
import 'package:c_breez/utils/external_browser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoonPayPage extends StatefulWidget {
  const MoonPayPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MoonPayPage> createState() => _MoonPayPageState();
}

class _MoonPayPageState extends State<MoonPayPage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final moonPayBloc = context.read<MoonPayBloc>();
      moonPayBloc.fetchMoonpayUrl();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              color: themeData.iconTheme.color,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        body: BlocListener<MoonPayBloc, MoonPayState>(
          listener: (context, state) {
            if (state is MoonPayStateError) {
              _closeOnError(context);
            } else if (state is MoonPayStateUrlReady) {
              if (state.webViewStatus == WebViewStatus.error) {
                _closeOnError(context);
              } else {
                _launchMoonPayUrl(context, state.url);
              }
            }
          },
          child: const MoonpayLoading(),
        ),
      ),
    );
  }

  // I'm opening a chrome tab instead on loading a in-app web view
  // https://breez-tech.slack.com/archives/C0585MDPTRD/p1685453667050779
  void _launchMoonPayUrl(BuildContext context, String url) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop();
      launchLinkOnExternalBrowser(
        context,
        linkAddress: url,
      );
    });
  }

  // Right now we are not dealing with errors edge case scenarios, discussion:
  // https://breez-tech.slack.com/archives/C0585MDPTRD/p1685453667050779
  void _closeOnError(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoonPayBloc>().dispose();
      Navigator.of(context).pop();
    });
  }
}

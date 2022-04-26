import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StatusText extends StatefulWidget {
  final AccountState account;
  final String? message;

  const StatusText(this.account, {this.message});

  @override
  State<StatefulWidget> createState() {
    return _StatusTextState();
  }
}

class _StatusTextState extends State<StatusText> {
  @override
  Widget build(BuildContext context) {
    if (widget.message != null) {
     return LoadingAnimatedText(widget.message!);
    }

    if (widget.account.status == AccountStatus.CONNECTING) {
      return LoadingAnimatedText("",
          textAlign: TextAlign.center,
          textElements: <TextSpan>[
            TextSpan(
                text: "Breez is ",
                style: Theme.of(context).accentTextTheme.bodyText2),
            _LinkTextSpan(
                text: "opening a secure channel",
                // url: widget.account.channelFundingTxUrl,
                style: Theme.of(context)
                    .accentTextTheme
                    .bodyText2!
                    .copyWith(decoration: TextDecoration.underline)),
            // style: theme.blueLinkStyle),
            TextSpan(
              text:
                  " with our server. This might take a while, but don't worry, we'll notify you when the app is ready to send and receive payments.",
              style: Theme.of(context).accentTextTheme.bodyText2,
            )
          ]);
    }

    if (widget.account.status == AccountStatus.CONNECTED) {
      return AutoSizeText(
        "Breez is ready to receive funds.",
        style: Theme.of(context).accentTextTheme.bodyText2,
        textAlign: TextAlign.center,
        minFontSize: MinFontSize(context).minFontSize,
        stepGranularity: 0.1,
      );
    }

    return Text("Breez is opening a secure connection",
            style: Theme.of(context).accentTextTheme.bodyText2,
            textAlign: TextAlign.center);
  }
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle? style, String? url, String? text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url!, forceSafariVC: false);
              });
}

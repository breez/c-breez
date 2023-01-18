import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'particles_animations.dart';

class SuccessfulPaymentRoute extends StatefulWidget {
  final Function()? onPrint;

  const SuccessfulPaymentRoute({
    this.onPrint,
  });

  @override
  State<StatefulWidget> createState() {
    return SuccessfulPaymentRouteState();
  }
}

class SuccessfulPaymentRouteState extends State<SuccessfulPaymentRoute>
    with WidgetsBindingObserver {
  Future? _showFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_showFuture == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _showFuture = showDialog(
          useRootNavigator: false,
          context: context,
          barrierDismissible: true,
          builder: (context) => _buildDialog(context),
        ).whenComplete(() => Navigator.of(context).pop());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Particles(
            50,
            color: Colors.blue.withAlpha(150),
          ),
        ),
      ],
    );
  }

  Widget _buildDialog(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).pop(),
      child: AlertDialog(
        title: widget.onPrint != null
            ? Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: texts.successful_payment_print,
                  iconSize: 24.0,
                  color: themeData.appBarTheme.actionsIconTheme!.color,
                  icon: SvgPicture.asset(
                    "src/icon/printer.svg",
                    color: themeData.appBarTheme.actionsIconTheme!.color,
                    fit: BoxFit.contain,
                    width: 24.0,
                    height: 24.0,
                  ),
                  onPressed: widget.onPrint,
                ),
              )
            : const SizedBox(
                height: 40,
              ),
        titlePadding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 40),
        content: _buildSuccessfulPaymentMessage(context),
      ),
    );
  }

  _buildSuccessfulPaymentMessage(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          texts.successful_payment_received,
          textAlign: TextAlign.center,
          style: themeData.primaryTextTheme.headline4!.copyWith(fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Container(
            decoration: BoxDecoration(
              color: themeData.dialogTheme.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Image(
              image: const AssetImage("src/icon/ic_done.png"),
              height: 48.0,
              color: themeData.isLightTheme
                  ? const Color.fromRGBO(0, 133, 251, 1.0)
                  : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

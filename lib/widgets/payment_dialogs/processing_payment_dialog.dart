import 'dart:async';

import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/loading_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'payment_request_dialog.dart';

const _kPaymentListItemHeight = 72.0;

class ProcessingPaymentDialog extends StatefulWidget {
  final GlobalKey firstPaymentItemKey;
  final Function(PaymentRequestState state) _onStateChange;
  final bool popOnCompletion;
  final Future Function() paymentFunc;
  final double minHeight;

  const ProcessingPaymentDialog(
    this.paymentFunc,
    this.firstPaymentItemKey,
    this._onStateChange,
    this.minHeight, {
    Key? key,
    this.popOnCompletion = false,
  }) : super(key: key);

  @override
  ProcessingPaymentDialogState createState() {
    return ProcessingPaymentDialogState();
  }
}

class ProcessingPaymentDialogState extends State<ProcessingPaymentDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool? _animating = false;
  double? startHeight;
  Animation<Color?>? colorAnimation;
  Animation<double>? borderAnimation;
  Animation<double>? opacityAnimation;
  Animation<RelativeRect>? transitionAnimation;
  final GlobalKey _dialogKey = GlobalKey();
  ModalRoute? _currentRoute;
  double? channelsSyncProgress;
  final Completer? synchronizedCompleter = Completer<bool>();

  @override
  void initState() {
    super.initState();
    _payAncClose();
    _currentRoute = ModalRoute.of(context);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    colorAnimation = ColorTween(
      begin: Theme.of(context).canvasColor,
      end: Theme.of(context).backgroundColor,
    ).animate(controller!)
      ..addListener(() {
        setState(() {});
      });
    borderAnimation = Tween<double>(begin: 0.0, end: 12.0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.ease));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller!, curve: Curves.ease));
    controller!.value = 1.0;
    controller!.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (widget.popOnCompletion) {
          Navigator.of(context).removeRoute(_currentRoute!);
        }
        widget._onStateChange(PaymentRequestState.PAYMENT_COMPLETED);
      }
    });
  }

  _payAncClose() {
    widget.paymentFunc().then((value) => _animateClose()).catchError((err) {
      if (widget.popOnCompletion) {
        Navigator.of(context).removeRoute(_currentRoute!);
      }
      widget._onStateChange(PaymentRequestState.PAYMENT_COMPLETED);
    });
  }

  void _animateClose() {
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      _initializeTransitionAnimation();
      setState(() {
        _animating = true;
        controller!.reverse();
      });
    });
  }

  void _initializeTransitionAnimation() {
    final queryData = MediaQuery.of(context);
    final statusBarHeight = queryData.padding.top;
    final safeArea = queryData.size.height - statusBarHeight;
    RenderBox? box = _dialogKey.currentContext!.findRenderObject() as RenderBox;
    startHeight = box.size.height;
    double yMargin = (safeArea - box.size.height) / 2;

    final endPosition = RelativeRect.fromLTRB(40.0, yMargin, 40.0, yMargin);
    RelativeRect startPosition = endPosition;
    final paymentCtx = widget.firstPaymentItemKey.currentContext;
    if (paymentCtx != null) {
      RenderBox paymentTableBox = paymentCtx.findRenderObject() as RenderBox;
      final dy = paymentTableBox.localToGlobal(Offset.zero).dy;
      final start = dy - statusBarHeight;
      final end = safeArea - start - _kPaymentListItemHeight;
      startPosition = RelativeRect.fromLTRB(0.0, start, 0.0, end);
    }
    transitionAnimation = RelativeRectTween(
      begin: startPosition,
      end: endPosition,
    ).animate(controller!);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animating!
        ? _createAnimatedContent(context)
        : _createContentDialog(context);
  }

  List<Widget> _buildProcessingPaymentDialog(BuildContext context) {
    final themeData = theme.customData[theme.themeId]!;
    return [
      _buildTitle(context),
      _buildContent(context),
      Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Image.asset(
          themeData.loaderAssetPath,
          height: 64.0,
          colorBlendMode: themeData.loaderColorBlendMode,
          color: theme.themeId == "BLUE"
              ? colorAnimation!.value ?? Colors.transparent
              : null,
          gaplessPlayback: true,
        ),
      )
    ];
  }

  Widget _createContentDialog(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(
          minHeight: widget.minHeight,
        ),
        child: Column(
          key: _dialogKey,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: _buildProcessingPaymentDialog(context),
        ),
      ),
    );
  }

  Widget _createAnimatedContent(BuildContext context) {
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);

    return Opacity(
      opacity: opacityAnimation!.value,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            PositionedTransition(
              rect: transitionAnimation!,
              child: Container(
                height: startHeight,
                width: queryData.size.width,
                decoration: ShapeDecoration(
                  color: theme.themeId == "BLUE"
                      ? colorAnimation!.value
                      : controller!.value >= 0.25
                          ? themeData.backgroundColor
                          : colorAnimation!.value,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      borderAnimation!.value,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildProcessingPaymentDialog(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildTitle(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Container(
      height: 64.0,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
      child: Text(
        texts.processing_payment_dialog_processing_payment,
        style: themeData.dialogTheme.titleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);
    final queryData = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: SizedBox(
        width: queryData.size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimatedText(
              texts.processing_payment_dialog_wait,
              textStyle: themeData.dialogTheme.contentTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

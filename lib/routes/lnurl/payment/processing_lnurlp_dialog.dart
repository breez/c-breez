import 'dart:async';

import 'package:c_breez/widgets/payment_dialogs/processing_payment/processing_payment_animated_content.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment/processing_payment_content.dart';
import 'package:flutter/material.dart';

const _kPaymentListItemHeight = 72.0;

class ProcessingLNURLPaymentDialog extends StatefulWidget {
  final GlobalKey? firstPaymentItemKey;
  final double minHeight;
  final Future Function() paymentFunc;

  const ProcessingLNURLPaymentDialog({
    this.firstPaymentItemKey,
    this.minHeight = 220,
    Key? key,
    required this.paymentFunc,
  }) : super(key: key);

  @override
  ProcessingPaymentDialogState createState() {
    return ProcessingPaymentDialogState();
  }
}

class ProcessingPaymentDialogState extends State<ProcessingLNURLPaymentDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  bool _animating = false;
  double? startHeight;
  Animation<Color?>? colorAnimation;
  Animation<double>? borderAnimation;
  Animation<double>? opacityAnimation;
  Animation<RelativeRect>? transitionAnimation;
  final GlobalKey _dialogKey = GlobalKey();

  double? channelsSyncProgress;
  final Completer? synchronizedCompleter = Completer<bool>();

  @override
  void initState() {
    super.initState();
    _payAndClose();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    controller!.value = 1.0;
    controller!.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {}
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colorAnimation = ColorTween(
      begin: Theme.of(context).canvasColor,
      end: Theme.of(context).colorScheme.background,
    ).animate(controller!)
      ..addListener(() {
        setState(() {});
      });
    borderAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: controller!, curve: Curves.ease),
    );
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller!, curve: Curves.ease),
    );
  }

  _payAndClose() async {
    final navigator = Navigator.of(context);
    widget.paymentFunc().then((payResult) async {
      await _animateClose();
      navigator.pop(payResult);
    }).catchError((err) {
      navigator.pop(err);
    });
  }

  Future _animateClose() {
    return Future.delayed(const Duration(milliseconds: 50)).then((_) {
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
    RenderBox? box = _dialogKey.currentContext!.findRenderObject() as RenderBox;
    startHeight = box.size.height;
    double yMargin = (queryData.size.height - box.size.height - 24) / 2;

    final endPosition = RelativeRect.fromLTRB(40.0, yMargin, 40.0, yMargin);
    RelativeRect startPosition = endPosition;
    final paymentCtx = widget.firstPaymentItemKey?.currentContext;
    if (paymentCtx != null) {
      RenderBox paymentTableBox = paymentCtx.findRenderObject() as RenderBox;
      final dy = paymentTableBox.localToGlobal(Offset.zero).dy;
      final start = dy - statusBarHeight;
      final end = queryData.size.height - start - _kPaymentListItemHeight;
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
    return _animating
        ? ProcessingPaymentAnimatedContent(
            color: colorAnimation?.value ?? Colors.transparent,
            opacity: opacityAnimation!.value,
            moment: controller!.value,
            border: borderAnimation!.value,
            startHeight: startHeight ?? 0.0,
            transitionAnimation: transitionAnimation!,
            child: const ProcessingPaymentContent(),
          )
        : Dialog(
            child: Container(
              constraints: BoxConstraints(
                minHeight: widget.minHeight,
              ),
              child: ProcessingPaymentContent(
                dialogKey: _dialogKey,
              ),
            ),
          );
  }
}

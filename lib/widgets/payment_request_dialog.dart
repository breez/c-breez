import 'dart:async';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/routes/home/theme.dart';
import 'package:c_breez/widgets/payment_confirmation_dialog.dart';
import 'package:c_breez/widgets/payment_request_info_dialog.dart';
import 'package:c_breez/widgets/processing_payment_dialog.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PaymentRequestState {
  PAYMENT_REQUEST,
  WAITING_FOR_CONFIRMATION,
  PROCESSING_PAYMENT,
  USER_CANCELLED,
  PAYMENT_COMPLETED
}

class PaymentRequestDialog extends StatefulWidget {
  final BuildContext context;
  final AccountBloc accountBloc;
  final Invoice invoice;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final Function() onComplete;

  const PaymentRequestDialog(this.context, this.accountBloc, this.invoice,
      this.firstPaymentItemKey, this.scrollController, this.onComplete);

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog> {
  PaymentRequestState? _state;
  String? _amountToPayStr;
  Int64? _amountToPay;
  ModalRoute? _currentRoute;
  String? _bolt11;

  @override
  void initState() {
    super.initState();
    _state = PaymentRequestState.PAYMENT_REQUEST;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: withBreezTheme(context, showPaymentRequestDialog()),
    );
  }

  // Do not pop dialog if there's a payment being processed
  Future<bool> _onWillPop() async {
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return false;
    }

    widget.accountBloc.cancelPayment(widget.invoice.bolt11);
    return true;
  }

  Widget showPaymentRequestDialog() {
    const double minHeight = 220;
    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return ProcessingPaymentDialog(widget.context, () {
        return widget.accountBloc
            .sendPayment(widget.invoice.bolt11, _amountToPay!);
      }, widget.accountBloc, widget.firstPaymentItemKey, _onStateChange,
          minHeight);
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return PaymentConfirmationDialog(
          widget.accountBloc,
          widget.invoice.bolt11,
          _amountToPay!,
          _amountToPayStr!,
          () => _onStateChange(PaymentRequestState.USER_CANCELLED),
          (bolt11, amount) {
        setState(() {
          _bolt11 = bolt11;
          _amountToPay = amount;
          _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
        });
      }, minHeight);
    } else {
      return PaymentRequestInfoDialog(
          widget.context,
          widget.accountBloc,
          widget.invoice,
          () => _onStateChange(PaymentRequestState.USER_CANCELLED),
          () => _onStateChange(PaymentRequestState.WAITING_FOR_CONFIRMATION),
          (bolt11, amount) {
        _bolt11 = bolt11;
        _amountToPay = amount;
        _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
      }, (map) => _setAmountToPay(map), minHeight);
    }
  }

  void _onStateChange(PaymentRequestState state) {
    if (state == PaymentRequestState.PAYMENT_COMPLETED) {
      Navigator.of(context).removeRoute(_currentRoute!);
      widget.onComplete();
      return;
    }
    if (state == PaymentRequestState.USER_CANCELLED) {
      Navigator.of(context).removeRoute(_currentRoute!);
      widget.accountBloc.cancelPayment(widget.invoice.bolt11);
      widget.onComplete();
      return;
    }
    setState(() {
      _state = state;
    });
  }

  void _setAmountToPay(Map<String, dynamic> map) {
    _amountToPay = map["_amountToPay"];
    _amountToPayStr = map["_amountToPayStr"];
  }
}

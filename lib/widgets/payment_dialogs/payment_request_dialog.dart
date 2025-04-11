import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_confirmation_dialog.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_info_dialog.dart';
import 'package:c_breez/widgets/payment_dialogs/processing_payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PaymentRequestState {
  PAYMENT_REQUEST,
  WAITING_FOR_CONFIRMATION,
  PROCESSING_PAYMENT,
  USER_CANCELLED,
  PAYMENT_COMPLETED
}

class PaymentRequestDialog extends StatefulWidget {
  final Invoice invoice;
  final GlobalKey firstPaymentItemKey;

  const PaymentRequestDialog(
    this.invoice,
    this.firstPaymentItemKey, {
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return PaymentRequestDialogState();
  }
}

class PaymentRequestDialogState extends State<PaymentRequestDialog> {
  late AccountBloc accountBloc;
  PaymentRequestState? _state;
  String? _amountToPayStr;
  int? _amountToPaySat;

  ModalRoute? _currentRoute;

  @override
  void initState() {
    super.initState();
    accountBloc = context.read<AccountBloc>();
    _state = PaymentRequestState.PAYMENT_REQUEST;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
          return;
        } else {
          final NavigatorState navigator = Navigator.of(context);
          accountBloc.cancelPayment(widget.invoice.bolt11);
          if (_currentRoute != null && _currentRoute!.isActive) {
            navigator.removeRoute(_currentRoute!);
          }
          return;
        }
      },
      child: showPaymentRequestDialog(),
    );
  }

  Widget showPaymentRequestDialog() {
    const double minHeight = 220;

    if (_state == PaymentRequestState.PROCESSING_PAYMENT) {
      return ProcessingPaymentDialog(
        firstPaymentItemKey: widget.firstPaymentItemKey,
        minHeight: minHeight,
        paymentFunc: () => accountBloc.sendPayment(
          widget.invoice.bolt11,
          widget.invoice.amountMsat == 0 ? _amountToPaySat! * 1000 : null,
        ),
        onStateChange: (state) => _onStateChange(state),
      );
    } else if (_state == PaymentRequestState.WAITING_FOR_CONFIRMATION) {
      return PaymentConfirmationDialog(
        widget.invoice.bolt11,
        _amountToPaySat!,
        _amountToPayStr!,
        () => _onStateChange(PaymentRequestState.USER_CANCELLED),
        (bolt11, amountSat) => setState(() {
          _amountToPaySat = amountSat;
          _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
        }),
        minHeight,
      );
    } else {
      return PaymentRequestInfoDialog(
        widget.invoice,
        () => _onStateChange(PaymentRequestState.USER_CANCELLED),
        () => _onStateChange(PaymentRequestState.WAITING_FOR_CONFIRMATION),
        (bolt11, amountSat) {
          _amountToPaySat = amountSat;
          _onStateChange(PaymentRequestState.PROCESSING_PAYMENT);
        },
        (map) => _setAmountToPaySat(map),
        minHeight,
      );
    }
  }

  void _onStateChange(PaymentRequestState state) {
    if (state == PaymentRequestState.PAYMENT_COMPLETED) {
      Navigator.of(context).pop();
      return;
    }
    if (state == PaymentRequestState.USER_CANCELLED) {
      Navigator.of(context).pop();
      accountBloc.cancelPayment(widget.invoice.bolt11);
      return;
    }
    setState(() {
      _state = state;
    });
  }

  void _setAmountToPaySat(Map<String, dynamic> map) {
    _amountToPaySat = map["_amountToPaySat"];
    _amountToPayStr = map["_amountToPayStr"];
  }
}

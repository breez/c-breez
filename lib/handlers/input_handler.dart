import 'dart:convert';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/input/input_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/invoice.dart';
import 'package:c_breez/routes/lnurl/lnurl_payment_dialog.dart';
import 'package:c_breez/routes/lnurl/success_action_dialog.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/payment_dialogs/payment_request_dialog.dart'
    as payment_request;
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../routes/lnurl/lnurl_payment_page.dart';
import '../widgets/route.dart';

class InputHandler {
  final BuildContext _context;
  final GlobalKey firstPaymentItemKey;
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldController;

  ModalRoute? _loaderRoute;
  bool _handlingRequest = false;

  InputHandler(
    this._context,
    this.firstPaymentItemKey,
    this.scrollController,
    this.scaffoldController,
  ) {
    final InputBloc inputBloc = _context.read<InputBloc>();
    inputBloc.stream.listen((inputState) {
      if (_handlingRequest ||
          inputState.invoice == null ||
          inputState.lnurlParseResult == null) {
        return;
      }
      _handlingRequest = true;
      handleInput(inputState);
    }).onError((error) {
      _setLoading(false);
      showFlushbar(_context, message: error.toString());
    });
  }

  void handleLNURLPayRequest(payParams) {
    final AccountBloc accountBloc = _context.read<AccountBloc>();
    bool fixedAmount = payParams.minSendable == payParams.maxSendable;
    if (fixedAmount && !(payParams.commentAllowed > 0)) {
      showDialog(
        useRootNavigator: false,
        context: _context,
        barrierDismissible: false,
        builder: (_) => LNURLPaymentDialog(
          payParams,
          onComplete: () {
            Map<String, String> qParams = {
              'amount': payParams.maxSendable.toString(),
            };
            processLNURLPayment(payParams, qParams, accountBloc);
          },
          onCancel: () {
            _handlingRequest = false;
            showFlushbar(_context, message: 'Payment Cancelled.');
          },
        ),
      );
    } else {
      Navigator.of(_context).push(
        FadeInRoute(
          builder: (_) => LNURLPaymentPage(
            payParams: payParams,
            onSubmit: (payerDataMap) {
              processLNURLPayment(payParams, payerDataMap, accountBloc);
            },
          ),
        ),
      );
      _handlingRequest = false;
    }
  }

  Future<void> processLNURLPayment(
    LNURLPayParams parseResult,
    Map<String, String> qParams,
    AccountBloc accountBloc,
  ) async {
    {
      try {
        _setLoading(true);
        final texts = _context.texts();
        /*
          5. LN WALLET makes a GET request using
             <callback><?|&>amount=<milliSatoshi>
             amount being the amount specified by the user in millisatoshis.
        */
        Uri uri =
            Uri.parse(parseResult.callback).replace(queryParameters: qParams);
        var response = await http.get(uri).timeout(const Duration(seconds: 60));
        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception(
            texts.lnurl_webview_error_message(parseResult.domain),
          );
        }
        /*
         6. LN Service takes the GET request and returns JSON response of form:
            {
              pr: string, // bech32-serialized lightning invoice
              routes: [] // an empty array
              "successAction": Object (optional)
            }
            or
            {"status":"ERROR", "reason":"error details..."}
        */
        Map<String, dynamic> decoded = json.decode(response.body);
        LNURLPayResult lnurlPayResult = LNURLPayResult.fromJson(decoded);
        /* TODO:
            7. LN WALLET Verifies that h tag in provided invoice is a hash of metadata string converted to byte array in UTF-8 encoding.
            8. LN WALLET Verifies that amount in provided invoice equals the amount previously specified by user.
            9. LN WALLET pays the invoice, no additional user confirmation is required at this point.
        */
        await accountBloc
            .sendPayment(lnurlPayResult.pr, Int64.parseInt(qParams['amount']!))
            .whenComplete(() {
          LNURLPaySuccessAction? successAction = lnurlPayResult.successAction;
          if (successAction != null) {
            showDialog(
              useRootNavigator: false,
              context: _context,
              builder: (_) => SuccessActionDialog(
                getSuccessActionMessage(lnurlPayResult, successAction),
                url: successAction.url,
              ),
            );
          }
        });
        _handlingRequest = false;
        _setLoading(false);
      } catch (error) {
        _handlingRequest = false;
        _setLoading(false);
        showFlushbar(_context, message: error.toString());
      }
    }
  }

  _setLoading(bool visible) {
    if (visible && _loaderRoute == null) {
      _loaderRoute = createLoaderRoute(_context);
      Navigator.of(_context).push(_loaderRoute!);
      return;
    }

    if (!visible && _loaderRoute != null) {
      Navigator.removeRoute(_context, _loaderRoute!);
      _loaderRoute = null;
    }
  }

  String getSuccessActionMessage(
      LNURLPayResult lnurlPayResult, LNURLPaySuccessAction successAction) {
    switch (successAction.tag) {
      case 'aes':
        return decryptSuccessActionAesPayload(
          preimage: lnurlPayResult.pr,
          successAction: successAction,
        );
      case 'url':
        return successAction.description!;
      case 'message':
        return successAction.message!;
    }
    return '';
  }

  void handleInput(InputState inputState) {
    if (inputState.invoice != null) {
      handleInvoice(inputState.invoice);
    }
    final lnurlParseResult = inputState.lnurlParseResult;
    if (lnurlParseResult != null) {
      if (lnurlParseResult.payParams != null) {
        handleLNURLPayRequest(lnurlParseResult.payParams);
      }
      if (lnurlParseResult.withdrawalParams != null) {}
    }
  }

  void handleInvoice(Invoice? invoice) {
    showDialog(
      useRootNavigator: false,
      context: _context,
      barrierDismissible: false,
      builder: (_) => payment_request.PaymentRequestDialog(
        invoice!,
        firstPaymentItemKey,
        scrollController,
        () => _handlingRequest = false,
      ),
    );
  }
}

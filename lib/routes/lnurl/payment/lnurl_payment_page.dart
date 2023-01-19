import 'dart:convert';

import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/lnurl/payment/pay_response.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_metadata.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/receivable_btc_box.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("LNURLPaymentPage");

class LNURLPaymentPage extends StatefulWidget {
  final sdk.LnUrlPayRequestData requestData;
  final String domain;
  final PayerDataRecordField? name;
  final AuthRecord? auth;
  final PayerDataRecordField? email;
  final PayerDataRecordField? identifier;

  const LNURLPaymentPage({
    required this.requestData,
    required this.domain,
    this.name,
    this.auth,
    this.email,
    this.identifier,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LNURLPaymentPageState();
  }
}

class LNURLPaymentPageState extends State<LNURLPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  final _nameController = TextEditingController();
  final _k1Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _identifierController = TextEditingController();
  late final bool fixedAmount;

  @override
  void initState() {
    super.initState();
    fixedAmount =
        widget.requestData.minSendable == widget.requestData.maxSendable;
    if (fixedAmount) {
      _amountController.text =
          (widget.requestData.maxSendable ~/ 1000).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final currencyState = context.read<CurrencyBloc>().state;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: Text(texts.lnurl_payment_page_title),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.domain.isNotEmpty) ...[
                  Center(
                    child: Text(
                      fixedAmount
                          ? texts.lnurl_payment_page_domain_pay(
                              widget.domain,
                              widget.requestData.maxSendable,
                            )
                          : widget.domain,
                      style: themeData.textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
                LNURLMetadata({
                  for (var v in json.decode(widget.requestData.metadataStr))
                    v[0] as String: v[1],
                }),
                if (widget.requestData.commentAllowed > 0) ...[
                  TextFormField(
                    controller: _commentController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    maxLength: widget.requestData.commentAllowed,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      labelText: texts.lnurl_payment_page_comment,
                    ),
                  )
                ],
                if (!fixedAmount) ...[
                  AmountFormField(
                    context: context,
                    texts: texts,
                    bitcoinCurrency: currencyState.bitcoinCurrency,
                    controller: _amountController,
                    validatorFn: validatePayment,
                  ),
                  ReceivableBTCBox(
                    receiveLabel: texts.lnurl_fetch_invoice_limit(
                      (widget.requestData.minSendable ~/ 1000).toString(),
                      (widget.requestData.maxSendable ~/ 1000).toString(),
                    ),
                  ),
                ],
                if (widget.name?.mandatory == true) ...[
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) => value != null
                        ? null
                        : texts.breez_avatar_dialog_your_name,
                  )
                ],
                if (widget.auth?.mandatory == true) ...[
                  TextFormField(
                    controller: _k1Controller,
                    keyboardType: TextInputType.text,
                    validator: (value) => value != null
                        ? null
                        : texts.lnurl_payment_page_enter_k1,
                  )
                ],
                if (widget.email?.mandatory == true) ...[
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null
                        ? EmailValidator.validate(value)
                            ? null
                            : texts.order_card_country_email_invalid
                        : texts.order_card_country_email_empty,
                  )
                ],
                if (widget.identifier?.mandatory == true) ...[
                  TextFormField(
                    controller: _identifierController,
                  )
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        stickToBottom: true,
        text: texts.lnurl_payment_page_action_pay,
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final accountBloc = context.read<AccountBloc>();
            final currencyBloc = context.read<CurrencyBloc>();
            final navigator = Navigator.of(context);
            var loaderRoute = createLoaderRoute(context);
            navigator.push(loaderRoute);

            try {
              final amount = currencyBloc.state.bitcoinCurrency
                  .parse(_amountController.text);
              final comment = _commentController.text;
              _log.v("LNURL payment of $amount sats where "
                  "min is ${widget.requestData.minSendable} msats "
                  "and max is ${widget.requestData.maxSendable} msats.");
              final resp = await accountBloc.sendLNURLPayment(
                amount: amount,
                comment: comment,
                reqData: widget.requestData,
              );
              navigator.removeRoute(loaderRoute);
              if (resp is sdk.LnUrlPayResult_EndpointSuccess) {
                _log.v("LNURL payment success, action: ${resp.data}");
                navigator.pop(LNURLPaymentPageResult(
                  successAction: resp.data,
                ));
              } else if (resp is sdk.LnUrlPayResult_EndpointError) {
                _log.v("LNURL payment failed: ${resp.data.reason}");
                navigator.pop(LNURLPaymentPageResult(
                  error: resp.data.reason,
                ));
              } else {
                _log.w("Unknown response from sendLNURLPayment: $resp");
                navigator.pop(LNURLPaymentPageResult(
                  error: texts.lnurl_payment_page_unknown_error,
                ));
              }
            } catch (e) {
              _log.w("Error sending LNURL payment", ex: e);
              navigator.removeRoute(loaderRoute);
              navigator.pop(LNURLPaymentPageResult(error: e));
            }
          }
        },
      ),
    );
  }

  String? validatePayment(int amount) {
    final texts = context.texts();
    final accBloc = context.read<AccountBloc>();
    final lspInfo = context.read<LSPBloc>().state?.lspInfo;
    final currencyState = context.read<CurrencyBloc>().state;

    final maxSendable = widget.requestData.maxSendable ~/ 1000;
    if (amount > maxSendable) {
      return texts.lnurl_payment_page_error_exceeds_limit(maxSendable);
    }

    final minSendable = widget.requestData.minSendable ~/ 1000;
    if (amount < minSendable) {
      return texts.lnurl_payment_page_error_below_limit(minSendable);
    }

    int? channelMinimumFee;
    if (lspInfo != null) {
      channelMinimumFee = lspInfo.channelMinimumFeeMsat ~/ 1000;
    }

    return PaymentValidator(
      accBloc.validatePayment,
      currencyState.bitcoinCurrency,
      channelMinimumFee: channelMinimumFee,
      texts: context.texts(),
    ).validateIncoming(amount);
  }
}

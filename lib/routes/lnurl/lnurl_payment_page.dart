import 'dart:convert';

import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/receivable_btc_box.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/lnurl_metadata.dart';

class LNURLPaymentPage extends StatefulWidget {
  final LNURLPayParams payParams;
  final Function() onComplete;

  const LNURLPaymentPage(
    this.payParams, {
    Key? key,
    required this.onComplete,
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
    fixedAmount = widget.payParams.minSendable == widget.payParams.maxSendable;
    if (fixedAmount) {
      _amountController.text = (widget.payParams.maxSendable ~/ 1000).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final currencyState = context.read<CurrencyBloc>().state;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: const Text("LNURL Invoice"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.payParams.domain.isNotEmpty) ...[
                Center(
                  child: Text(
                    fixedAmount
                        ? '${widget.payParams.domain} is requesting you to pay ${widget.payParams.maxSendable ~/ 1000} sats.'
                        : widget.payParams.domain,
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
              LNURLMetadata(
                {
                  for (var v in json.decode(widget.payParams.metadata))
                    v[0] as String: v[1]
                },
              ),
              if (widget.payParams.commentAllowed > 0) ...[
                TextFormField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.done,
                  maxLines: null,
                  maxLength: widget.payParams.commentAllowed,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: InputDecoration(
                    labelText: '${texts.payment_details_dialog_share_comment} (optional)',
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
                  receiveLabel: '${texts.lnurl_fetch_invoice_limit(
                    (widget.payParams.minSendable ~/ 1000).toString(),
                    (widget.payParams.maxSendable ~/ 1000).toString(),
                  )} sats.',
                ),
              ],
              if (widget.payParams.payerData?.name?.mandatory == true) ...[
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) => value != null
                      ? null
                      : texts.breez_avatar_dialog_your_name,
                )
              ],
              if (widget.payParams.payerData?.auth?.mandatory == true) ...[
                TextFormField(
                  controller: _k1Controller,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value != null ? null : "Please enter a k1",
                )
              ],
              if (widget.payParams.payerData?.email?.mandatory == true) ...[
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
              if (widget.payParams.payerData?.identifier?.mandatory ==
                  true) ...[
                TextFormField(
                  controller: _identifierController,
                )
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        stickToBottom: true,
        text: "PAY",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final AccountBloc accountBloc = context.read<AccountBloc>();

            // Create payerDataMap
            final Int64 amount = Int64.parseInt(_amountController.text) * 1000;
            final String comment = _commentController.text;
            final PayerData payerData = PayerData(
              name:
                  _nameController.text.isNotEmpty ? _nameController.text : null,
              pubkey: widget.payParams.payerData?.pubkey?.mandatory == true
                  ? 'hex(<randomly generated secp256k1 pubkey>)'
                  : null,
              auth: _k1Controller.text.isNotEmpty
                  ? Auth(
                      key: 'hex(<linkingKey>)',
                      k1: _k1Controller.text,
                      sig:
                          'hex(sign(hexToBytes(<${_k1Controller.text}>), <linkingPrivKey>))')
                  : null,
              email: _emailController.text.isNotEmpty
                  ? _emailController.text
                  : null,
              identifier: _identifierController.text.isNotEmpty
                  ? _identifierController.text
                  : null,
            );
            final Map<String, String> payerDataMap = {
              "amount": amount.toString(),
              "comment": comment.toString(),
              "payerData": json.encode(payerData.toJson()),
            };
            // Create loader and process payment
            final navigator = Navigator.of(context);
            navigator.pop();
            var loaderRoute = createLoaderRoute(context);
            navigator.push(loaderRoute);
            await accountBloc
                .sendLNURLPayment(widget.payParams, payerDataMap)
                .onError(
              (error, stackTrace) {
                navigator.removeRoute(loaderRoute);
                widget.onComplete();
                throw Exception(error.toString());
              },
            ).then(
              (lnurlPayResult) => handleSuccessAction(context, lnurlPayResult),
            );
            navigator.removeRoute(loaderRoute);
            widget.onComplete();
          }
        },
      ),
    );
  }

  String? validatePayment(Int64 amount) {
    var accBloc = context.read<AccountBloc>();
    late final accountState = accBloc.state;
    late final lspStatus = context.read<LSPBloc>().state;
    late final currencyState = context.read<CurrencyBloc>().state;
    late final texts = context.texts();

    if (amount > (widget.payParams.maxSendable ~/ 1000)) {
      return "Exceeds maximum sendable amount: ${widget.payParams.maxSendable ~/ 1000}";
    }
    if (amount < (widget.payParams.minSendable ~/ 1000)) {
      return "Below minimum accepted amount: ${widget.payParams.minSendable ~/ 1000}";
    }

    if (lspStatus.currentLSP != null) {
      final channelMinimumFee = Int64(
        lspStatus.currentLSP!.channelMinimumFeeMsat ~/ 1000,
      );
      if (amount > accountState.maxInboundLiquidity &&
          amount <= channelMinimumFee) {
        return texts.invoice_insufficient_amount_fee(
          currencyState.bitcoinCurrency.format(channelMinimumFee),
        );
      }
    }

    return PaymentValidator(
            accBloc.validatePayment, currencyState.bitcoinCurrency)
        .validateIncoming(amount);
  }
}

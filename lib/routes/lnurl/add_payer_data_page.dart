import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:dart_lnurl/dart_lnurl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPayerDataPage extends StatefulWidget {
  final LNURLPayParams payParams;
  final Function(Map<dynamic, dynamic>) onSubmit;

  const AddPayerDataPage({
    Key? key,
    required this.payParams,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddPayerDataPageState();
  }
}

class AddPayerDataPageState extends State<AddPayerDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  final _nameController = TextEditingController();
  final _k1Controller = TextEditingController();
  final _emailController = TextEditingController();
  final _identifierController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: const Text("Add Payer Data"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value != null) {
                    try {
                      var numValue = int.parse(value);
                      if (numValue > widget.payParams.maxSendable &&
                          numValue < widget.payParams.minSendable) {
                        return "Enter an amount between ${widget.payParams.minSendable} and ${widget.payParams.maxSendable}.";
                      }
                    } catch (_) {
                      return "Enter a valid amount.";
                    }
                  }
                  return null;
                },
              ),
              if (widget.payParams.commentAllowed > 0) ...[
                TextFormField(
                  controller: _commentController,
                  maxLength: widget.payParams.commentAllowed,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                )
              ],
              if (widget.payParams.payerData != null &&
                  widget.payParams.payerData!.name != null &&
                  widget.payParams.payerData!.name!.mandatory) ...[
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) => value != null
                      ? null
                      : texts.breez_avatar_dialog_your_name,
                )
              ],
              if (widget.payParams.payerData != null &&
                  widget.payParams.payerData!.auth != null &&
                  widget.payParams.payerData!.auth!.mandatory) ...[
                TextFormField(
                  controller: _k1Controller,
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value != null ? null : "Please enter a k1",
                )
              ],
              if (widget.payParams.payerData != null &&
                  widget.payParams.payerData!.email != null &&
                  widget.payParams.payerData!.email!.mandatory) ...[
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
              if (widget.payParams.payerData != null &&
                  widget.payParams.payerData!.identifier != null &&
                  widget.payParams.payerData!.identifier!.mandatory) ...[
                TextFormField(
                  controller: _identifierController,
                )
              ],
              SingleButtonBottomBar(
                text: "Add Payer Data",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final int amount = int.parse(_amountController.text);
                    final String comment = _commentController.text;
                    final PayerData payerData = PayerData(
                      name: _nameController.text.isNotEmpty
                          ? _nameController.text
                          : null,
                      pubkey: widget.payParams.payerData != null &&
                              widget.payParams.payerData!.pubkey != null &&
                              widget.payParams.payerData!.pubkey!.mandatory
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
                    var payerDataMap = {
                      "amount": amount,
                      "comment": comment,
                      "payerData": payerData.toJson(),
                    };
                    widget.onSubmit(payerDataMap);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

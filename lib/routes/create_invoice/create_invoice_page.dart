import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/create_invoice/qr_code_dialog.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:c_breez/widgets/receivable_btc_box.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/successful_payment.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateInvoicePageState();
  }
}

class CreateInvoicePageState extends State<CreateInvoicePage> {
  late final texts = context.texts();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction = KeyboardDoneAction();

  late final AccountBloc accountBloc = context.read<AccountBloc>();
  late final accountState = accountBloc.state;
  late final lspStatus = context.read<LSPBloc>().state;
  late final CurrencyBloc currencyBloc = context.read<CurrencyBloc>();
  late final currencyState = currencyBloc.state;

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(focusNodes: [_amountFocusNode]);
    super.initState();
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: Text(texts.invoice_title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 40.0),
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    maxLength: 90,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      labelText: texts.invoice_description_label,
                    ),
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  AmountFormField(
                    context: context,
                    texts: texts,
                    bitcoinCurrency: currencyState.bitcoinCurrency,
                    focusNode: _amountFocusNode,
                    controller: _amountController,
                    validatorFn: validatePayment,
                    style: theme.FieldTextStyle.textStyle,
                  ),
                  ReceivableBTCBox(
                    onTap: () {
                      _amountController.text =
                          currencyState.bitcoinCurrency.format(
                        accountState.maxAllowedToReceive,
                        includeDisplayName: false,
                        userInput: true,
                      );
                    },
                  ),
                  AvailabilityMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: SingleButtonBottomBar(
          stickToBottom: true,
          text: texts.invoice_action_create,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _createInvoice();
            }
          },
        ),
      ),
    );
  }

  Future _createInvoice() async {
    final navigator = Navigator.of(context);
    var currentRoute = ModalRoute.of(navigator.context)!;
    Future<LNInvoice> invoice = accountBloc.addInvoice(
      description: _descriptionController.text,
      amountSats: currencyBloc.state.bitcoinCurrency.parse(_amountController.text),
    );
    navigator.pop();
    Widget dialog = FutureBuilder(
      future: invoice,
      builder: (BuildContext context, AsyncSnapshot<LNInvoice> invoice) {
        return QrCodeDialog(
          invoice.data,
          invoice.error,
          (result) {
            onPaymentFinished(result, currentRoute, navigator);
          },
        );
      },
    );

    return showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => dialog,
    );
  }

  void onPaymentFinished(
    dynamic result,
    ModalRoute currentRoute,
    NavigatorState navigator,
  ) {
    if (result == true) {
      if (currentRoute.isCurrent) {
        navigator.push(
          TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()),
        );
      }
    } else {
      if (result is String) {
        showFlushbar(context, title: "", message: result);
      }
    }
  }

  String? validatePayment(int amount) {
    int? channelMinimumFee;
    if (lspStatus.currentLSP != null) {
      channelMinimumFee =
        lspStatus.currentLSP!.channelMinimumFeeMsat ~/ 1000
      ;
    }

    return PaymentValidator(
      accountBloc.validatePayment,
      currencyState.bitcoinCurrency,
      channelMinimumFee: channelMinimumFee,
    ).validateIncoming(amount);
  }
}

class AvailabilityMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);
    final accountState = context.read<AccountBloc>().state;
    String? availabilityMessage;
    if (accountState.status == AccountStatus.CONNECTING) {
      availabilityMessage = texts.invoice_availability_message_opening_channel;
      if (availabilityMessage.endsWith('.')) {
        availabilityMessage += '.';
      }
    }

    return availabilityMessage != null
        ? Container(
            padding: const EdgeInsets.only(
              top: 32.0,
              left: 16.0,
              right: 16.0,
            ),
            child: Column(
              children: [
                Text(
                  availabilityMessage,
                  textAlign: TextAlign.center,
                  style: themeData.textTheme.headline6!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

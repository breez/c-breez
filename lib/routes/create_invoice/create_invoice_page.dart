import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/routes/create_invoice/qr_code_dialog.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_dialog.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:c_breez/widgets/receivable_btc_box.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("CreateInvoicePage");

class CreateInvoicePage extends StatefulWidget {
  final Function(LNURLPageResult? result)? onFinish;
  final LnUrlWithdrawRequestData? requestData;

  const CreateInvoicePage({
    Key? key,
    this.requestData,
    this.onFinish,
  })  : assert(
          requestData == null || (onFinish != null),
          "If you are using LNURL withdraw, you must provide an onFinish callback.",
        ),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateInvoicePageState();
  }
}

class CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  var _doneAction = KeyboardDoneAction();

  @override
  void initState() {
    _doneAction = KeyboardDoneAction(focusNodes: [_amountFocusNode]);

    final data = widget.requestData;
    if (data != null) {
      _amountController.text = (data.maxWithdrawable ~/ 1000).toString();
      _descriptionController.text = data.defaultDescription;
    }
    super.initState();
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

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
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 40.0),
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
                  BlocBuilder<CurrencyBloc, CurrencyState>(
                    builder: (context, currencyState) {
                      return AmountFormField(
                        context: context,
                        texts: texts,
                        bitcoinCurrency: currencyState.bitcoinCurrency,
                        focusNode: _amountFocusNode,
                        controller: _amountController,
                        validatorFn: (v) => validatePayment(context, v),
                        style: theme.FieldTextStyle.textStyle,
                      );
                    },
                  ),
                  BlocBuilder2<AccountBloc, AccountState, CurrencyBloc, CurrencyState>(
                    builder: (context, accountState, currencyState) {
                      return ReceivableBTCBox(
                        onTap: () {
                          _amountController.text = currencyState.bitcoinCurrency.format(
                            accountState.maxAllowedToReceive,
                            includeDisplayName: false,
                            userInput: true,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SingleButtonBottomBar(
        stickToBottom: true,
        text: widget.requestData != null ? texts.invoice_action_redeem : texts.invoice_action_create,
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            final data = widget.requestData;
            if (data != null) {
              _withdraw(context, data);
            } else {
              _createInvoice(context);
            }
          }
        },
      ),
    );
  }

  Future<void> _withdraw(
    BuildContext context,
    LnUrlWithdrawRequestData data,
  ) async {
    _log.v("Withdraw request: description=${data.defaultDescription}, k1=${data.k1}, "
        "min=${data.minWithdrawable}, max=${data.maxWithdrawable}");
    final CurrencyBloc currencyBloc = context.read<CurrencyBloc>();

    final navigator = Navigator.of(context);
    navigator.pop();

    showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLWithdrawDialog(
        requestData: data,
        amountSats: currencyBloc.state.bitcoinCurrency.parse(
          _amountController.text,
        ),
        onFinish: widget.onFinish!,
      ),
    );
  }

  Future _createInvoice(BuildContext context) async {
    _log.v("Create invoice: description=${_descriptionController.text}, amount=${_amountController.text}");
    final navigator = Navigator.of(context);
    final currentRoute = ModalRoute.of(navigator.context)!;
    final accountBloc = context.read<AccountBloc>();
    final currencyBloc = context.read<CurrencyBloc>();

    Future<ReceivePaymentResponse> receivePaymentResponse = accountBloc.addInvoice(
      description: _descriptionController.text,
      amountSats: currencyBloc.state.bitcoinCurrency.parse(_amountController.text),
    );
    navigator.pop();
    Widget dialog = FutureBuilder(
      future: receivePaymentResponse,
      builder: (BuildContext context, AsyncSnapshot<ReceivePaymentResponse> snapshot) {
        _log.v("Building QrCodeDialog with invoice: ${snapshot.data}, error: ${snapshot.error}");
        return QrCodeDialog(
          snapshot.data,
          snapshot.error,
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
    _log.v("Payment finished: $result");
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

  String? validatePayment(BuildContext context, int amount) {
    final lspInfo = context.read<LSPBloc>().state?.lspInfo;
    int? channelMinimumFee =
        lspInfo != null ? lspInfo.openingFeeParamsList.values.first.minMsat ~/ 1000 : null;

    return PaymentValidator(
      validatePayment: _validatePayment,
      currency: context.read<CurrencyBloc>().state.bitcoinCurrency,
      channelMinimumFee: channelMinimumFee,
      texts: context.texts(),
    ).validateIncoming(amount);
  }

  void _validatePayment(
    int amount,
    bool outgoing, {
    int? channelMinimumFee,
  }) {
    final data = widget.requestData;
    if (data != null) {
      if (amount > data.maxWithdrawable ~/ 1000) {
        throw PaymentExceededLimitError(data.maxWithdrawable ~/ 1000);
      }
      if (amount < data.minWithdrawable ~/ 1000) {
        throw PaymentBelowLimitError(data.minWithdrawable ~/ 1000);
      }
    }
    return context.read<AccountBloc>().validatePayment(
          amount,
          outgoing,
          channelMinimumFee: channelMinimumFee,
        );
  }
}

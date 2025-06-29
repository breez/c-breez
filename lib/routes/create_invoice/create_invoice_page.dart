import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/account/payment_error.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/ext/block_builder_extensions.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/routes/create_invoice/qr_code_dialog.dart';
import 'package:c_breez/routes/create_invoice/widgets/receivable_btc_box.dart';
import 'package:c_breez/routes/create_invoice/widgets/successful_payment.dart';
import 'package:c_breez/routes/lnurl/widgets/lnurl_page_result.dart';
import 'package:c_breez/routes/lnurl/withdraw/lnurl_withdraw_dialog.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/utils.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("CreateInvoicePage");

class CreateInvoicePage extends StatefulWidget {
  final Function(LNURLPageResult? result)? onFinish;
  final LnUrlWithdrawRequestData? requestData;

  const CreateInvoicePage({super.key, this.requestData, this.onFinish})
    : assert(
        requestData == null || (onFinish != null),
        "If you are using LNURL withdraw, you must provide an onFinish callback.",
      );

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
    super.initState();
    _doneAction = KeyboardDoneAction(focusNodes: [_amountFocusNode]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = widget.requestData;
      if (data != null) {
        final currencyState = context.read<CurrencyBloc>().state;
        _amountController.text = currencyState.bitcoinCurrency.format(
          data.maxWithdrawable.toInt() ~/ 1000,
          includeDisplayName: false,
        );
        _descriptionController.text = data.defaultDescription;
      }
    });
  }

  @override
  void dispose() {
    _doneAction.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    final lspState = context.watch<LSPBloc>().state;
    final cheapestFeeParams = lspState?.lspInfo?.openingFeeParamsList.values.first;
    final isChannelOpeningAvailable = lspState?.isChannelOpeningAvailable ?? false;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(leading: const back_button.BackButton(), title: Text(texts.invoice_title)),
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
                    decoration: InputDecoration(labelText: texts.invoice_description_label),
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
                        validatorFn: (v) => validatePayment(v),
                        style: theme.FieldTextStyle.textStyle,
                      );
                    },
                  ),
                  BlocBuilder3<AccountBloc, AccountState, CurrencyBloc, CurrencyState, LSPBloc, LspState?>(
                    builder: (context, accountState, currencyState, lspState) {
                      return ReceivableBTCBox(
                        onTap: () {
                          if (!isChannelOpeningAvailable && accountState.maxInboundLiquiditySat > 0) {
                            _amountController.text = currencyState.bitcoinCurrency.format(
                              accountState.maxInboundLiquiditySat,
                              includeDisplayName: false,
                              userInput: true,
                            );
                          } else if (!isChannelOpeningAvailable && accountState.maxInboundLiquiditySat == 0) {
                            // do nothing
                          } else {
                            _amountController.text = currencyState.bitcoinCurrency.format(
                              accountState.maxAllowedToReceiveSat,
                              includeDisplayName: false,
                              userInput: true,
                            );
                          }
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
              _withdraw(data);
            } else {
              _createInvoice(cheapestFeeParams);
            }
          }
        },
      ),
    );
  }

  Future<void> _withdraw(LnUrlWithdrawRequestData data) async {
    _log.info(
      "Withdraw request: description=${data.defaultDescription}, k1=${data.k1}, "
      "min=${data.minWithdrawable}, max=${data.maxWithdrawable}",
    );
    final CurrencyBloc currencyBloc = context.read<CurrencyBloc>();

    final navigator = Navigator.of(context);
    navigator.pop();

    showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => LNURLWithdrawDialog(
        requestData: data,
        amountSat: currencyBloc.state.bitcoinCurrency.parse(_amountController.text),
        onFinish: widget.onFinish!,
      ),
    );
  }

  Future _createInvoice(OpeningFeeParams? cheapestFeeParams) async {
    _log.info("Create invoice: description=${_descriptionController.text}, amount=${_amountController.text}");
    final navigator = Navigator.of(context);
    final currentRoute = ModalRoute.of(navigator.context)!;
    final accountBloc = context.read<AccountBloc>();
    final currencyBloc = context.read<CurrencyBloc>();

    Future<ReceivePaymentResponse> receivePaymentResponse = accountBloc.addInvoice(
      description: _descriptionController.text,
      amountMsat: currencyBloc.state.bitcoinCurrency.parse(_amountController.text) * 1000,
      chosenFeeParams: cheapestFeeParams,
    );
    navigator.pop();
    Widget dialog = FutureBuilder(
      future: receivePaymentResponse,
      builder: (BuildContext context, AsyncSnapshot<ReceivePaymentResponse> snapshot) {
        _log.info("Building QrCodeDialog with invoice: ${snapshot.data}, error: ${snapshot.error}");
        return QrCodeDialog(snapshot.data, snapshot.error, (result) {
          onPaymentFinished(result, currentRoute, navigator);
        });
      },
    );

    return showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => dialog,
    );
  }

  void onPaymentFinished(dynamic result, ModalRoute currentRoute, NavigatorState navigator) {
    _log.info("Payment finished: $result");
    if (result == true) {
      if (currentRoute.isCurrent) {
        navigator.push(TransparentPageRoute((ctx) => const SuccessfulPaymentRoute()));
      }
    } else {
      if (result is String) {
        showFlushbar(context, title: "", message: result);
      }
    }
  }

  String? validatePayment(int amountSat) {
    final lspInfo = context.read<LSPBloc>().state?.lspInfo;
    int? channelMinimumFeeSat = lspInfo != null && lspInfo.openingFeeParamsList.values.isNotEmpty
        ? lspInfo.openingFeeParamsList.values.first.minMsat.toInt() ~/ 1000
        : null;

    return PaymentValidator(
      validatePayment: _validatePayment,
      currency: context.read<CurrencyBloc>().state.bitcoinCurrency,
      channelCreationPossible: context.read<LSPBloc>().state?.isChannelOpeningAvailable ?? false,
      channelMinimumFeeSat: channelMinimumFeeSat,
      texts: context.texts(),
    ).validateIncoming(amountSat);
  }

  void _validatePayment(
    int amountSat,
    bool outgoing,
    bool channelCreationPossible, {
    int? channelMinimumFeeSat,
  }) {
    final data = widget.requestData;
    if (data != null) {
      if (amountSat > data.maxWithdrawable.toInt() ~/ 1000) {
        throw PaymentExceededLimitError(data.maxWithdrawable.toInt() ~/ 1000);
      }
      if (amountSat < data.minWithdrawable.toInt() ~/ 1000) {
        throw PaymentBelowLimitError(data.minWithdrawable.toInt() ~/ 1000);
      }
    }
    return context.read<AccountBloc>().validatePayment(
      amountSat,
      outgoing,
      channelCreationPossible,
      channelMinimumFeeSat: channelMinimumFeeSat,
    );
  }
}

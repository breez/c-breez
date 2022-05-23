import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/models/lsp.dart';
import 'package:c_breez/routes/create_invoice/qr_code_dialog.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/utils/payment_validator.dart';
import 'package:c_breez/widgets/amount_form_field/amount_form_field.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/keyboard_done_action.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:c_breez/widgets/transparent_page_route.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  KeyboardDoneAction _doneAction = KeyboardDoneAction();

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
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: const back_button.BackButton(),
        actions: const [],
        title: Text(texts.invoice_title),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, currencyState) {
        return BlocBuilder<AccountBloc, AccountState>(
          builder: (context, acc) {
            return BlocBuilder<LSPBloc, LSPState>(
              builder: (context, lspState) {
                String? validatePayment(Int64 amount) {
                  if (lspState.currentLSP != null) {
                    final channelMinimumFee = Int64(
                      lspState.currentLSP!.channelMinimumFeeMsat ~/ 1000,
                    );
                    if (amount > acc.maxInboundLiquidity &&
                        amount <= channelMinimumFee) {
                      return texts.invoice_insufficient_amount_fee(
                        currencyState.bitcoinCurrency.format(channelMinimumFee),
                      );
                    }
                  }
                  var accBloc = context.read<AccountBloc>();
                      return PaymentValidator(accBloc.validatePayment,
                          currencyState.bitcoinCurrency)
                      .validateIncoming(amount);
                }

                return Form(
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
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
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
                            _buildReceivableBTC(
                                context, acc, currencyState, lspState),
                            BlocBuilder<AccountBloc, AccountState>(
                              builder: (context, acc) {
                                String? message = _availabilityMessage(
                                  texts,
                                  acc,
                                );
                                if (message != null) {
                                  // In case error doesn't have a trailing full stop
                                  if (!message.endsWith('.')) {
                                    message += '.';
                                  }
                                  return Container(
                                    padding: const EdgeInsets.only(
                                      top: 32.0,
                                      left: 16.0,
                                      right: 16.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          message,
                                          textAlign: TextAlign.center,
                                          style: themeData.textTheme.headline6!
                                              .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 40.0,
        ),
        child: SingleButtonBottomBar(
          stickToBottom: true,
          text: texts.invoice_action_create,
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _createInvoice(
                context,
                context.read<InvoiceBloc>(),
                context.read<CurrencyBloc>(),
                context.read<AccountBloc>(),
              );
            }
          },
        ),
      ),
    );
  }

  Future _createInvoice(
    BuildContext context,
    InvoiceBloc invoiceBloc,
    CurrencyBloc currencyBloc,
    AccountBloc accountBloc,
  ) async {
    final navigator = Navigator.of(context);
    var currentRoute = ModalRoute.of(navigator.context)!;
    var invoice = await accountBloc.addInvoice(
        description: _descriptionController.text,
        amount:
            currencyBloc.state.bitcoinCurrency.parse(_amountController.text));
    navigator.pop();
    Widget dialog = QrCodeDialog(invoice, (result) {
      onPaymentFinished(result, currentRoute, navigator);
    });

    return showDialog(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (_) => dialog,
    );
  }

  String? _availabilityMessage(
    AppLocalizations texts,
    AccountState acc,
  ) {
    if (acc.status == AccountStatus.CONNECTING) {
      return texts.invoice_availability_message_opening_channel;
    }
    return null;
  }

  Widget _buildReceivableBTC(
    BuildContext context,
    AccountState acc,
    CurrencyState currencyState,
    LSPState lspStatus,
  ) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context)!;

    Widget warning = lspStatus.hasLSP
        ? const SizedBox()
        : WarningBox(
            boxPadding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatFeeMessage(
                      texts, acc, currencyState, lspStatus.currentLSP!),
                  style: themeData.textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 164,
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              texts.invoice_receive_label(
                currencyState.bitcoinCurrency.format(acc.maxAllowedToReceive),
              ),
              style: theme.textStyle,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
            ),
            warning,
          ],
        ),
        onTap: () =>
            _amountController.text = currencyState.bitcoinCurrency.format(
          acc.maxAllowedToReceive,
          includeDisplayName: false,
          userInput: true,
        ),
      ),
    );
  }

  String formatFeeMessage(
    AppLocalizations texts,
    AccountState accountModel,
    CurrencyState currencyState,
    LSPInfo lspInfo,
  ) {
    final connected = accountModel.status == AccountStatus.CONNECTED;
    final minFee = Int64(lspInfo.channelMinimumFeeMsat) ~/ 100;
    final minFeeFormatted = currencyState.bitcoinCurrency.format(minFee);
    final showMinFeeMessage = minFee > 0;
    final setUpFee = (lspInfo.channelFeePermyriad / 100).toString();
    final liquidity = currencyState.bitcoinCurrency.format(
      connected ? accountModel.maxInboundLiquidity : Int64(0),
    );

    if (connected && showMinFeeMessage) {
      return texts.invoice_ln_address_warning_with_min_fee_account_connected(
        setUpFee,
        minFeeFormatted,
        liquidity,
      );
    } else if (connected && !showMinFeeMessage) {
      return texts.invoice_ln_address_warning_without_min_fee_account_connected(
        setUpFee,
        liquidity,
      );
    } else if (!connected && showMinFeeMessage) {
      return texts
          .invoice_ln_address_warning_with_min_fee_account_not_connected(
        setUpFee,
        minFeeFormatted,
      );
    } else {
      return texts
          .invoice_ln_address_warning_without_min_fee_account_not_connected(
        setUpFee,
      );
    }
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
}

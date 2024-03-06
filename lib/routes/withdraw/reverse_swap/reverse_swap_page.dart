import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_bloc.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_state.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_state.dart';
import 'package:c_breez/routes/withdraw/model/withdraw_funds_model.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/confirmation_page/reverse_swap_confirmation_page.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/in_progress/reverse_swaps_in_progress_page.dart';
import 'package:c_breez/routes/withdraw/widgets/bitcoin_address_text_form_field.dart';
import 'package:c_breez/routes/withdraw/widgets/withdraw_funds_amount_text_form_field.dart';
import 'package:c_breez/routes/withdraw/widgets/withdraw_funds_available_btc.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/utils/validator_holder.dart';
import 'package:c_breez/widgets/amount_form_field/sat_amount_form_field_formatter.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ReverseSwapPage");

class ReverseSwapPage extends StatefulWidget {
  final BitcoinAddressData? btcAddressData;
  const ReverseSwapPage({super.key, required this.btcAddressData});

  @override
  State<ReverseSwapPage> createState() => _ReverseSwapPageState();
}

class _ReverseSwapPageState extends State<ReverseSwapPage> {
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _validatorHolder = ValidatorHolder();

  bool _withdrawMaxValue = false;
  Future<ReverseSwapPolicy>? _revSwapOptionsFuture;

  @override
  void initState() {
    super.initState();
    _fetchReverseSwapPairInfo();
    if (widget.btcAddressData != null) {
      _fillBtcAddressData(widget.btcAddressData!);
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchReverseSwapPairInfo();
    }
  }

  Future _fetchReverseSwapPairInfo() async {
    final revSwapBloc = context.read<ReverseSwapBloc>();
    setState(() {
      _revSwapOptionsFuture = revSwapBloc.onchainPaymentLimits();
    });
  }

  void _fillBtcAddressData(BitcoinAddressData addressData) {
    _addressController.text = addressData.address;
    if (addressData.amountSat != null) {
      _setAmount(addressData.amountSat!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bitcoinCurrency = context.read<CurrencyBloc>().state.bitcoinCurrency;

    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        title: Text(texts.reverse_swap_title),
      ),
      body: FutureBuilder<ReverseSwapPolicy>(
          future: _revSwapOptionsFuture,
          builder: (BuildContext context, AsyncSnapshot<ReverseSwapPolicy> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Loader(
                    color: themeData.primaryColor.withOpacity(0.5),
                  ),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Text(
                        texts.reverse_swap_upstream_generic_error_message(
                          extractExceptionMessage(snapshot.error!, texts),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  final maxSendableAmount = snapshot.data!.maxAmountSat;
                  return SafeArea(
                    child: BlocBuilder<RevSwapsInProgressBloc, RevSwapsInProgressState>(
                      builder: (context, inProgressSwapState) {
                        if (inProgressSwapState.isLoading) {
                          return Center(
                            child: Loader(
                              color: themeData.primaryColor.withOpacity(0.5),
                            ),
                          );
                        }

                        if (inProgressSwapState.reverseSwapsInProgress.isNotEmpty) {
                          return ReverseSwapsInProgressPage(
                            reverseSwaps: inProgressSwapState.reverseSwapsInProgress,
                          );
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    BitcoinAddressTextFormField(
                                      context: context,
                                      controller: _addressController,
                                      validatorHolder: _validatorHolder,
                                    ),
                                    WithdrawFundsAmountTextFormField(
                                      context: context,
                                      bitcoinCurrency: bitcoinCurrency,
                                      controller: _amountController,
                                      withdrawMaxValue: _withdrawMaxValue,
                                      balance: maxSendableAmount,
                                      policy: WithdrawFundsPolicy(
                                        WithdrawKind.withdraw_funds,
                                        snapshot.data!.paymentLimits.minSat,
                                        snapshot.data!.paymentLimits.maxSat,
                                      ),
                                    ),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        texts.withdraw_funds_use_all_funds,
                                        style: const TextStyle(color: Colors.white),
                                        maxLines: 1,
                                      ),
                                      trailing: Switch(
                                        value: _withdrawMaxValue,
                                        activeColor: Colors.white,
                                        onChanged: (bool value) async {
                                          setState(() {
                                            _withdrawMaxValue = value;
                                            if (_withdrawMaxValue) {
                                              _setAmount(maxSendableAmount);
                                            } else {
                                              _amountController.text = "";
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            WithdrawFundsAvailableBtc(maxSendableAmount: maxSendableAmount),
                            Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                              child: SubmitButton(
                                texts.withdraw_funds_action_next,
                                () async {
                                  final navigator = Navigator.of(context);
                                  if (_formKey.currentState?.validate() ?? false) {
                                    var loaderRoute = createLoaderRoute(context);
                                    navigator.push(loaderRoute);

                                    try {
                                      int amount = _getAmount();

                                      if (loaderRoute.isActive) {
                                        navigator.removeRoute(loaderRoute);
                                      }

                                      navigator.push(
                                        FadeInRoute(
                                          builder: (_) => ReverseSwapConfirmationPage(
                                            amountSat: amount,
                                            amountType: SwapAmountType.Receive,
                                            onchainRecipientAddress: _addressController.text,
                                            isMaxValue: _withdrawMaxValue,
                                          ),
                                        ),
                                      );
                                    } catch (error) {
                                      if (loaderRoute.isActive) {
                                        navigator.removeRoute(loaderRoute);
                                      }
                                      _log.severe("Received error: $error");
                                      if (!context.mounted) return;
                                      showFlushbar(
                                        context,
                                        message: texts.reverse_swap_upstream_generic_error_message(
                                          extractExceptionMessage(error, texts),
                                        ),
                                      );
                                    } finally {
                                      if (loaderRoute.isActive) {
                                        navigator.removeRoute(loaderRoute);
                                      }
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
                }
            }
          }),
    );
  }

  int _getAmount() {
    final bitcoinCurrency = context.read<CurrencyBloc>().state.bitcoinCurrency;

    int amount = 0;
    try {
      amount = bitcoinCurrency.parse(_amountController.text);
    } catch (e) {
      _log.warning("Failed to parse the input amount", e);
    }
    return amount;
  }

  void _setAmount(int amountSats) {
    final bitcoinCurrency = context.read<CurrencyBloc>().state.bitcoinCurrency;

    setState(() {
      _amountController.text = bitcoinCurrency
          .format(amountSats, includeDisplayName: false, userInput: true)
          .formatBySatAmountFormFieldFormatter();
    });
  }
}

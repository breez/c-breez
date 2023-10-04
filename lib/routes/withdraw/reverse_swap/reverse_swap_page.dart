import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/fee_options/fee_options_bloc.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_bloc.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_state.dart';
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
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _log = FimberLog("ReverseSwapPage");

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
  Future<ReverseSwapPairInfo>? _pairInfoFuture;

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
    final feeOptionsBloc = context.read<FeeOptionsBloc>();
    setState(() {
      _pairInfoFuture = feeOptionsBloc.fetchReverseSwapFees();
    });
  }

  void _fillBtcAddressData(BitcoinAddressData addressData) {
    _addressController.text = addressData.address;
    if (addressData.amountSat != null) {
      _setAmount(addressData.amountSat!);
    }

    /// TODO: When handling BTC addresses through InputHandler, display label & message of BitcoinAddressData
    /// The label of the address - e.g. name of the receiver.
    /// widget.btcAddressData!.label
    /// Message that describes the transaction to the user.
    /// widget.btcAddressData!.message
    /// Set amount field as readOnly if widget.btcAddressData!.amountSat is available
  }

  @override
  Widget build(BuildContext context) {
    final balance = context.read<AccountBloc>().state.balance;
    final bitcoinCurrency = context.read<CurrencyBloc>().state.bitcoinCurrency;

    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        title: Text(texts.reverse_swap_title),
      ),
      body: FutureBuilder<ReverseSwapPairInfo>(
          future: _pairInfoFuture,
          builder: (BuildContext context, AsyncSnapshot<ReverseSwapPairInfo> snapshot) {
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
                                      balance: balance,
                                      policy: WithdrawFundsPolicy(
                                        WithdrawKind.withdraw_funds,
                                        snapshot.data!.min,
                                        snapshot.data!.max,
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
                                              _setAmount(balance);
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
                            const WithdrawFundsAvailableBtc(),
                            Expanded(child: Container()),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                              child: SubmitButton(
                                texts.withdraw_funds_action_next,
                                () async {
                                  final navigator = Navigator.of(context);
                                  if (_formKey.currentState?.validate() ?? false) {
                                    final feeOptionsBloc = context.read<FeeOptionsBloc>();
                                    int amount = _getAmount();
                                    final boltzFees =
                                        await feeOptionsBloc.fetchReverseSwapFees(amountSat: amount);

                                    navigator.push(
                                      FadeInRoute(
                                        builder: (_) => ReverseSwapConfirmationPage(
                                          amountSat: amount,
                                          onchainRecipientAddress: _addressController.text,
                                          feesHash: boltzFees.feesHash,
                                          boltzFees: boltzFees.totalEstimatedFees,
                                        ),
                                      ),
                                    );
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
      _log.w("Failed to parse the input amount", ex: e);
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

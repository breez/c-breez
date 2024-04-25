import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_bloc.dart';
import 'package:c_breez/bloc/rev_swap_in_progress/rev_swap_in_progress_state.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/confirmation_page/reverse_swap_confirmation_page.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/in_progress/reverse_swaps_in_progress_page.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/reverse_swap_form.dart';
import 'package:c_breez/routes/withdraw/widgets/withdraw_funds_available_btc.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("ReverseSwapFormPage");

class ReverseSwapFormPage extends StatefulWidget {
  final BitcoinAddressData? btcAddressData;
  final BitcoinCurrency bitcoinCurrency;
  final OnchainPaymentLimitsResponse paymentLimits;

  const ReverseSwapFormPage({
    super.key,
    this.btcAddressData,
    required this.bitcoinCurrency,
    required this.paymentLimits,
  });

  @override
  State<ReverseSwapFormPage> createState() => _ReverseSwapFormPageState();
}

class _ReverseSwapFormPageState extends State<ReverseSwapFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _addressController = TextEditingController();
  bool _withdrawMaxValue = false;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ReverseSwapForm(
                  formKey: _formKey,
                  amountController: _amountController,
                  addressController: _addressController,
                  withdrawMaxValue: _withdrawMaxValue,
                  btcAddressData: widget.btcAddressData,
                  bitcoinCurrency: widget.bitcoinCurrency,
                  paymentLimits: widget.paymentLimits,
                  onChanged: (bool value) {
                    setState(() {
                      _withdrawMaxValue = value;
                    });
                  },
                ),
                const WithdrawFundsAvailableBtc(),
                Expanded(child: Container()),
                SingleButtonBottomBar(
                  text: texts.withdraw_funds_action_next,
                  onPressed: _prepareReverseSwap,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  int _getAmount() {
    int amount = 0;
    try {
      amount = widget.bitcoinCurrency.parse(_amountController.text);
    } catch (e) {
      _log.warning("Failed to parse the input amount", e);
    }
    return amount;
  }

  void _prepareReverseSwap() async {
    final texts = context.texts();
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
  }
}

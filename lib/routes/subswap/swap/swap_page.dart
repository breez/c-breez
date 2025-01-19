import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/swap_in_progress/swap_in_progress_bloc.dart';
import 'package:c_breez/bloc/swap_in_progress/swap_in_progress_state.dart';
import 'package:c_breez/routes/subswap/swap/widgets/address_widget_placeholder.dart';
import 'package:c_breez/routes/subswap/swap/widgets/deposit_widget.dart';
import 'package:c_breez/routes/subswap/swap/widgets/inprogress_swap.dart';
import 'package:c_breez/routes/subswap/swap/widgets/swap_error_message.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwapPage extends StatefulWidget {
  const SwapPage();

  @override
  State<StatefulWidget> createState() {
    return SwapPageState();
  }
}

class SwapPageState extends State<SwapPage> {
  SwapInfo? swapInProgress;
  SwapInfo? swapUnused;
  String? bitcoinAddress;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BlocBuilder<SwapInProgressBloc, SwapInProgressState>(
      builder: (context, swapState) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const back_button.BackButton(),
            title: Text(texts.invoice_btc_address_title),
          ),
          body: swapState.isLoading
              ? const AddressWidgetPlaceholder()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ...[
                        // Always show swap in progress first
                        if (swapState.inProgress != null)
                          SwapInprogress(swap: swapState.inProgress!)
                        else if (swapState.unused != null)
                          DepositWidget(swapState.unused!)
                      ],
                      if (swapState.error != null) ...[
                        DepositErrorMessage(
                            errorMessage: "${texts.invoice_btc_address_network_error}\n"
                                "${texts.invoice_receive_fail_message(extractExceptionMessage(swapState.error!, texts))}"),
                      ]
                    ],
                  ),
                ),
          bottomNavigationBar: swapState.error != null
              ? SingleButtonBottomBar(
                  text: texts.invoice_btc_address_action_retry,
                  onPressed: () => context.read<SwapInProgressBloc>().pollSwapInAddress(),
                )
              : const SizedBox(),
        );
      },
    );
  }
}

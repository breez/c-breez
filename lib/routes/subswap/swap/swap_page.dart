import 'package:breez_sdk/breez_bridge.dart';
import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:c_breez/bloc/swap_in/swap_in_bloc.dart';
import 'package:c_breez/bloc/swap_in/swap_in_state.dart';
import 'package:c_breez/routes/subswap/swap/widgets/inprogress_swap.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/single_button_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/address_widget_placeholder.dart';
import 'widgets/deposit_widget.dart';

class SwapPage extends StatefulWidget {
  const SwapPage();

  @override
  State<StatefulWidget> createState() {
    return SwapPageState();
  }
}

class SwapPageState extends State<SwapPage> {
  final BreezBridge breezLib = ServiceInjector().breezLib;
  SwapInfo? swapInProgress;
  SwapInfo? swapUnused;
  String? bitcoinAddress;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LspState?>(
      buildWhen: (previous, current) => previous?.lspInfo != null || current?.lspInfo != null,
      builder: (context, lspState) {
        return BlocBuilder<SwapInBloc, SwapInState>(builder: (context, swapState) {
          final SwapInBloc swapInBloc = context.read();
          final texts = context.texts();
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
                          if (swapState.unused != null)
                            DepositWidget(swapState.unused!)
                          else if (swapState.inProgress != null)
                            SwapInprogress(swap: swapState.inProgress!)
                        ],
                        if (swapState.error != null) ...[
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 50.0,
                              left: 30.0,
                              right: 30.0,
                            ),
                            child: Text("Error swapping", textAlign: TextAlign.center),
                          ),
                        ]
                      ],
                    ),
                  ),
            bottomNavigationBar: swapState.error != null
                ? SingleButtonBottomBar(
                    text: texts.invoice_btc_address_action_retry,
                    onPressed: () async {
                      swapInBloc.pollSwapAddress();
                    },
                  )
                : const SizedBox(),
          );
        });
      },
    );
  }
}

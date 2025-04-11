import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/reverse_swap/reverse_swap_bloc.dart';
import 'package:c_breez/routes/withdraw/reverse_swap/reverse_swap_form_page.dart';
import 'package:c_breez/utils/exceptions.dart';
import 'package:c_breez/widgets/back_button.dart' as back_button;
import 'package:c_breez/widgets/loader.dart';
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
  Future<OnchainPaymentLimitsResponse>? _onchainPaymentLimitsFuture;

  @override
  void initState() {
    super.initState();
    _fetchOnchainPaymentLimits();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchOnchainPaymentLimits();
    }
  }

  Future _fetchOnchainPaymentLimits() async {
    _log.info("Fetching onchain payment limits");
    final revSwapBloc = context.read<ReverseSwapBloc>();
    setState(() {
      _onchainPaymentLimitsFuture = revSwapBloc.onchainPaymentLimits();
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const back_button.BackButton(),
        title: Text(texts.reverse_swap_title),
      ),
      body: FutureBuilder<OnchainPaymentLimitsResponse>(
        future: _onchainPaymentLimitsFuture,
        builder: (BuildContext context, AsyncSnapshot<OnchainPaymentLimitsResponse> snapshot) {
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
          }
          if (snapshot.connectionState != ConnectionState.done && !snapshot.hasData) {
            return Center(
              child: Loader(
                color: themeData.primaryColor.withValues(alpha: 0.5),
              ),
            );
          }

          return ReverseSwapFormPage(
            bitcoinCurrency: context.read<CurrencyBloc>().state.bitcoinCurrency,
            btcAddressData: widget.btcAddressData,
            paymentLimits: snapshot.data!,
          );
        },
      ),
    );
  }
}

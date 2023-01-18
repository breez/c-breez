import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_state.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

final _log = FimberLog("QrActionButton");

class QrActionButton extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;

  const QrActionButton(
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LSPBloc, LspState?>(
      builder: (context, lspState) {
        final connected = (lspState?.lspInfo != null);

        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: FloatingActionButton(
            onPressed: (connected) ? () => _scanBarcode(context) : null,
            child: SvgPicture.asset(
              "src/icon/qr_scan.svg",
              color: connected
                  ? theme.BreezColors.white[500]
                  : Theme.of(context).disabledColor,
              fit: BoxFit.contain,
              width: 24.0,
              height: 24.0,
            ),
          ),
        );
      },
    );
  }

  void _scanBarcode(BuildContext context) {
    final texts = context.texts();
    InputBloc inputBloc = context.read<InputBloc>();

    _log.v("Start qr code scan");
    Navigator.pushNamed<String>(context, "/qr_scan").then(
      (barcode) {
        _log.v("Scanned string: '$barcode'");
        if (barcode == null) return;
        if (barcode.isEmpty) {
          showFlushbar(
            context,
            message: texts.qr_action_button_error_code_not_detected,
          );
          return;
        }
        inputBloc.addIncomingInput(barcode);
      },
    );
  }
}

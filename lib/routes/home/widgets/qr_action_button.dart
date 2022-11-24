import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/bloc/lsp/lsp_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class QrActionButton extends StatelessWidget {
  final GlobalKey firstPaymentItemKey;

  const QrActionButton(
    this.firstPaymentItemKey, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InputBloc inputBloc = context.read<InputBloc>();
    return BlocBuilder<LSPBloc, LspInformation?>(
      builder: (context, lsp) {
        final connected = (lsp != null);

        return Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: FloatingActionButton(
            onPressed: connected
                ? () async {
                    final navigator = Navigator.of(context);
                    String? scannedString =
                        await navigator.pushNamed("/qr_scan");
                    if (scannedString != null && scannedString.isEmpty) {
                      showFlushbar(context,
                          message: "QR code wasn't detected.");
                      return;
                    }
                    inputBloc.addIncomingInput(scannedString!);
                  }
                : null,
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
}

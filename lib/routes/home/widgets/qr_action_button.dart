import 'package:c_breez/bloc/input/input_bloc.dart';
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

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: FloatingActionButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          String? scannedString = await navigator.pushNamed("/qr_scan");
          if (scannedString != null && scannedString.isEmpty) {
            showFlushbar(context, message: "QR code wasn't detected.");
            return;
          }
          inputBloc.addIncomingInput(scannedString!);
        },
        child: SvgPicture.asset(
          "src/icon/qr_scan.svg",
          color: theme.BreezColors.white[500],
          fit: BoxFit.contain,
          width: 24.0,
          height: 24.0,
        ),
      ),
    );
  }
}

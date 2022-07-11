import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:c_breez/routes/spontaneous_payment/spontaneous_payment_page.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/bip21.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:validators/validators.dart';

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
          String lower = scannedString!.toLowerCase();

          // bip 121
          String? lnInvoice = extractBolt11FromBip21(lower);
          lower = (lnInvoice ?? lower).toLowerCase();

          // regular lightning invoice.
          if (lower.startsWith("lightning:") || lower.startsWith("ln")) {
            inputBloc.addIncomingInput(scannedString);
            return;
          }

          var nodeID = parseNodeId(scannedString);
          if (nodeID != null) {
            navigator.push(FadeInRoute(
              builder: (_) =>
                  SpontaneousPaymentPage(nodeID, firstPaymentItemKey),
            ));
            return;
          }

          // Open on whenever app the system links to
          if (await canLaunchUrlString(scannedString)) {
            _handleWebAddress(context, scannedString);
            return;
          }

          // Open on browser
          final validUrl = isURL(
            scannedString,
            requireProtocol: true,
            allowUnderscore: true,
          );
          if (validUrl) {
            _handleWebAddress(context, scannedString);
            return;
          }

          showFlushbar(context, message: "QR code cannot be processed.");
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

  void _handleWebAddress(BuildContext context, String url) {
    var dialogTheme = Theme.of(context).dialogTheme;
    var size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: Container(
            height: 64.0,
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            child: const Text(
              "Open Link",
              textAlign: TextAlign.center,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    url,
                    style: dialogTheme.contentTextStyle!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 0.0,
                    height: 16.0,
                  ),
                  Text(
                    "Are you sure you want to open this link?",
                    style: dialogTheme.contentTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.transparent;
                    }
                    return Theme.of(context)
                        .textTheme
                        .button!
                        .color!; // Defer to the widget's default.
                  },
                ),
              ),
              child: Text(
                "NO",
                style: Theme.of(context).primaryTextTheme.button,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.transparent;
                    }
                    return Theme.of(context)
                        .textTheme
                        .button!
                        .color!; // Defer to the widget's default.
                  },
                ),
              ),
              child: Text(
                "YES",
                style: Theme.of(context).primaryTextTheme.button,
              ),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await launchUrlString(url);
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }
}

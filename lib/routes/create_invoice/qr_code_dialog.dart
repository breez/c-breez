import 'dart:async';

import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/bloc/invoice/invoice_bloc.dart';
import 'package:c_breez/bloc/invoice/invoice_state.dart';
import 'package:c_breez/models/account.dart';
import 'package:c_breez/models/currency.dart';
import 'package:c_breez/services/injector.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/widgets/compact_qr_image.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/warning_box.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_extend/share_extend.dart';

class QrCodeDialog extends StatefulWidget {
  final BuildContext context;
  final Invoice _invoice;
  final Function(dynamic result) _onFinish;

  const QrCodeDialog(this.context, this._invoice, this._onFinish);

  @override
  State<StatefulWidget> createState() {
    return QrCodeDialogState();
  }
}

class QrCodeDialogState extends State<QrCodeDialog> with SingleTickerProviderStateMixin {
  Animation<double>? _opacityAnimation;
  ModalRoute? _currentRoute;
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller!, curve: Curves.ease));
    _controller!.value = 1.0;
    _controller!.addStatusListener((status) async {
      if (status == AnimationStatus.dismissed && mounted) {
        onFinish(true);
      }
    });
    super.initState();
    context.read<InvoiceBloc>().trackPayment(widget._invoice.paymentHash).then((value) {
      Timer(const Duration(milliseconds: 1000), () {
        if (mounted) {
          _controller!.reverse();
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentRoute ??= ModalRoute.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return _buildQrCodeDialog();
  }

  Widget _buildQrCodeDialog() {
    return BlocBuilder<CurrencyBoc, CurrencyState>(builder: (context, currencyState) {
      return BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, invoiceState) {
        return FadeTransition(
          opacity: _opacityAnimation!,
          child: SimpleDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Invoice",
                  style: Theme.of(context).dialogTheme.titleTextStyle,
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 2.0, left: 14.0),
                      icon: const Icon(IconData(0xe917, fontFamily: 'icomoon')),
                      color: Theme.of(context).primaryTextTheme.button!.color!,
                      onPressed: () {
                        ShareExtend.share("lightning:" + widget._invoice.bolt11, "text");
                      },
                    ),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 14.0, left: 2.0),
                      icon: const Icon(IconData(0xe90b, fontFamily: 'icomoon')),
                      color: Theme.of(context).primaryTextTheme.button!.color!,
                      onPressed: () {
                        ServiceInjector().device.setClipboardText(widget._invoice.bolt11);
                        showFlushbar(context,
                            message: "Invoice data was copied to your clipboard.", duration: const Duration(seconds: 3));
                      },
                    )
                  ],
                )
              ],
            ),
            titlePadding: const EdgeInsets.fromLTRB(20.0, 22.0, 0.0, 8.0),
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0, bottom: 20.0),
            children: <Widget>[
              AnimatedCrossFade(
                firstChild: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 310.0,
                    child: Align(
                        alignment: const Alignment(0, -0.33),
                        child: SizedBox(
                          height: 80.0,
                          width: 80.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryTextTheme.button!.color!),
                            backgroundColor: Theme.of(context).backgroundColor,
                          ),
                        ))),
                secondChild: widget._invoice.bolt11 == null
                    ? const SizedBox()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: SizedBox(
                                width: 230.0,
                                height: 230.0,
                                child: CompactQRImage(
                                  data: widget._invoice.bolt11,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 16.0)),
                          SizedBox(width: MediaQuery.of(context).size.width, child: _buildExpiryAndFeeMessage(currencyState)),
                          const Padding(padding: EdgeInsets.only(top: 16.0)),
                        ],
                      ),
                duration: const Duration(seconds: 1),
                crossFadeState: widget._invoice.bolt11 == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              _buildCloseButton()
            ],
          ),
        );
      });
    });
  }

  Widget _buildExpiryAndFeeMessage(CurrencyState currencyState) {
    String _message = "";

    _message = "";
    var lspFee = widget._invoice.lspFee;
    if (lspFee != 0) {
      String conversionText = "";
      if (currencyState.fiatCurrency != null && currencyState.fiatExchangeRate != null) {
        FiatConversion conversion = FiatConversion(currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);
        conversionText = " (${conversion.format(Int64(lspFee))})";
      }
      _message = "A setup fee of ${BitcoinCurrency.SAT.format(Int64(lspFee))}$conversionText is applied to this invoice. ";
    }
    _message += "Keep Breez open until the payment is completed.";

    return WarningBox(
      boxPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      backgroundColor: theme.themeId == "BLUE" ? const Color(0xFFf3f8fc) : null,
      borderColor: theme.themeId == "BLUE" ? const Color(0xFF0085fb) : null,
      child: Text(
        _message,
        textAlign: TextAlign.center,
        style: Theme.of(context).primaryTextTheme.caption,
      ),
    );
  }

  Widget _buildCloseButton() {
    return TextButton(
      onPressed: (() {
        onFinish(false);
      }),
      child: Text("CLOSE", style: Theme.of(context).primaryTextTheme.button),
    );
  }

  onFinish(dynamic result) {
    if (_currentRoute != null) {
      Navigator.removeRoute(context, _currentRoute!);
    }
    widget._onFinish(result);
  }
}

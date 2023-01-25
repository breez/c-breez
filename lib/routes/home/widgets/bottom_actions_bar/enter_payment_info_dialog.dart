import 'package:c_breez/bloc/input/input_bloc.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/lnurl.dart';
import 'package:c_breez/utils/node_id.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPaymentInfoDialog extends StatefulWidget {
  final GlobalKey paymentItemKey;

  const EnterPaymentInfoDialog({required this.paymentItemKey});

  @override
  State<StatefulWidget> createState() {
    return EnterPaymentInfoDialogState();
  }
}

class EnterPaymentInfoDialogState extends State<EnterPaymentInfoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _paymentInfoController = TextEditingController();
  final _paymentInfoFocusNode = FocusNode();

  String _scannerErrorMessage = "";

  @override
  void initState() {
    super.initState();
    _paymentInfoController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24.0, 22.0, 0.0, 16.0),
      title: Text(texts.payment_info_dialog_title),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
      content: _buildPaymentInfoForm(context),
      actions: _buildActions(context),
    );
  }

  Theme _buildPaymentInfoForm(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    return Theme(
      data: themeData.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: theme.greyBorderSide,
          ),
        ),
        hintColor: themeData.dialogTheme.contentTextStyle!.color!,
        primaryColor: themeData.textTheme.labelLarge!.color,
        colorScheme: ColorScheme.dark(
          primary: themeData.textTheme.labelLarge!.color!,
          error:
              themeData.isLightTheme ? Colors.red : themeData.colorScheme.error,
        ),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: texts.payment_info_dialog_hint,
                    suffixIcon: IconButton(
                      padding: const EdgeInsets.only(top: 21.0),
                      alignment: Alignment.bottomRight,
                      icon: Image(
                        image: const AssetImage("src/icon/qr_scan.png"),
                        color: themeData.primaryIconTheme.color,
                        fit: BoxFit.contain,
                        width: 24.0,
                        height: 24.0,
                      ),
                      tooltip: texts.payment_info_dialog_barcode,
                      onPressed: () => _scanBarcode(context),
                    ),
                  ),
                  focusNode: _paymentInfoFocusNode,
                  controller: _paymentInfoController,
                  style: TextStyle(
                    color: themeData.primaryTextTheme.headlineMedium!.color,
                  ),
                  validator: (v) {
                    var value = v!;
                    if (parseNodeId(value) == null &&
                        _decodeInvoice(value) == null &&
                        !isLightningAddress(value)) {
                      return texts.payment_info_dialog_error;
                    }
                    return null;
                  },
                ),
                _scannerErrorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _scannerErrorMessage,
                          style: theme.validatorStyle,
                        ),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    texts.payment_info_dialog_hint_expanded,
                    style: theme.FieldTextStyle.labelStyle.copyWith(
                      fontSize: 13.0,
                      color: themeData.isLightTheme
                          ? theme.BreezColors.grey[500]
                          : theme.BreezColors.white[200],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = context.texts();

    List<Widget> actions = [
      SimpleDialogOption(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.payment_info_dialog_action_cancel,
          style: themeData.primaryTextTheme.labelLarge,
        ),
      )
    ];

    if (_paymentInfoController.text.isNotEmpty) {
      actions.add(
        SimpleDialogOption(
          onPressed: (() async {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop();
              final inputBloc = context.read<InputBloc>();
              inputBloc.addIncomingInput(_paymentInfoController.text);
            }
          }),
          child: Text(
            texts.payment_info_dialog_action_approve,
            style: themeData.primaryTextTheme.labelLarge,
          ),
        ),
      );
    }
    return actions;
  }

  Future _scanBarcode(BuildContext context) async {
    final texts = context.texts();

    FocusScope.of(context).requestFocus(FocusNode());
    String? barcode = await Navigator.pushNamed<String>(context, "/qr_scan");
    if (barcode == null) {
      return;
    }
    if (barcode.isEmpty) {
      if (!mounted) return;
      showFlushbar(
        context,
        message: texts.payment_info_dialog_error_qrcode,
      );
      return;
    }
    setState(() {
      _paymentInfoController.text = barcode;
      _scannerErrorMessage = "";
    });
  }

  String? _decodeInvoice(String invoiceString) {
    String normalized = invoiceString.toLowerCase();
    if (normalized.startsWith("lightning:")) {
      normalized = normalized.substring(10);
    }
    if (normalized.startsWith("ln") && !normalized.startsWith("lnurl")) {
      return invoiceString;
    }
    return null;
  }
}

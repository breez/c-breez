import 'package:auto_size_text/auto_size_text.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/bloc/currency/currency_state.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/fiat_conversion.dart';
import 'package:c_breez/utils/min_font_size.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../flushbar.dart';
import 'breez_dropdown.dart';

class CurrencyConverterDialog extends StatefulWidget {
  final Function(String string) _onConvert;
  final String? Function(Int64 amount) validatorFn;
  final CurrencyBloc _currencyBloc;

  const CurrencyConverterDialog(
    this._currencyBloc,
    this._onConvert,
    this.validatorFn,
  );

  @override
  CurrencyConverterDialogState createState() {
    return CurrencyConverterDialogState();
  }
}

class CurrencyConverterDialogState extends State<CurrencyConverterDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fiatAmountController = TextEditingController();
  final FocusNode _fiatAmountFocusNode = FocusNode();

  AnimationController? _controller;
  Animation<Color?>? _colorAnimation;

  double? _exchangeRate;

  final AutoSizeGroup _autoSizeGroup = AutoSizeGroup();

  final bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _fiatAmountController.addListener(() => setState(() {}));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // Loop back to start and stop
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller!.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller!.stop();
      }
    });

    widget._currencyBloc.fetchExchangeRates().catchError((value) {
      final texts = AppLocalizations.of(context)!;
      if (mounted) {
        setState(() {
          Navigator.pop(context);
          showFlushbar(
            context,
            message: texts.currency_converter_dialog_error_exchange_rate,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _fiatAmountController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, currencyState) {
        if (currencyState.preferredCurrencies.isEmpty ||
            !currencyState.fiatEnabled) {
          return const Loader();
        }

        double exchangeRate = currencyState.fiatExchangeRate!;
        _updateExchangeLabel(exchangeRate);

        return AlertDialog(
          title: _dialogBody(context, currencyState),
          titlePadding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 8.0),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
          content: _dialogContent(context, currencyState),
          actions: _buildActions(context, currencyState),
        );
      },
    );
  }

  Widget _dialogBody(BuildContext context, CurrencyState currencyState) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context)!;

    final items = currencyState.preferredCurrencies.map((value) {
      var fiatCurrencyData = currencyState.fiatCurrenciesData
          .firstWhere((c) => c.shortName == value);
      return DropdownMenuItem<String>(
        value: fiatCurrencyData.shortName,
        child: Material(
          child: SizedBox(
            width: 36,
            child: AutoSizeText(
              fiatCurrencyData.shortName,
              textAlign: TextAlign.left,
              style: themeData.dialogTheme.titleTextStyle,
              maxLines: 1,
              minFontSize: MinFontSize(context).minFontSize,
              stepGranularity: 0.1,
              group: _autoSizeGroup,
            ),
          ),
        ),
      );
    });

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 0.0, bottom: 2.0),
              child: AutoSizeText(
                texts.currency_converter_dialog_title,
                maxLines: 1,
                minFontSize: MinFontSize(context).minFontSize,
                stepGranularity: 0.1,
                group: _autoSizeGroup,
              ),
            ),
          ),
          Theme(
            data: themeData.copyWith(
              canvasColor: themeData.backgroundColor,
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: BreezDropdownButton(
                  onChanged: (value) => _selectFiatCurrency(value!.toString()),
                  value: currencyState.fiatShortName,
                  iconEnabledColor:
                      themeData.dialogTheme.titleTextStyle!.color!,
                  style: themeData.dialogTheme.titleTextStyle!,
                  items: items.toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dialogContent(BuildContext context, CurrencyState currencyState) {
    final themeData = Theme.of(context);
    var fiatConversion = FiatConversion(
        currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);

    final int? fractionSize = currencyState.fiatCurrency!.fractionSize;
    final isBlue = theme.themeId == "BLUE";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: theme.greyBorderSide,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: theme.greyBorderSide,
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isBlue ? Colors.red : themeData.errorColor,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isBlue ? Colors.red : themeData.errorColor,
                ),
              ),
              errorMaxLines: 2,
              errorStyle: themeData.primaryTextTheme.caption!.copyWith(
                color: isBlue ? Colors.red : themeData.errorColor,
              ),
              prefix: Text(
                currencyState.fiatCurrency!.symbol,
                style: themeData.dialogTheme.contentTextStyle,
              ),
            ),
            // Do not allow '.' when fractionSize is 0 and only allow fiat currencies fractionSize number of digits after decimal point
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                fractionSize == 0
                    ? RegExp(r'\d+')
                    : RegExp("^\\d+\\.?\\d{0,$fractionSize}"),
              ),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            focusNode: _fiatAmountFocusNode,
            autofocus: true,
            onEditingComplete: () => _fiatAmountFocusNode.unfocus(),
            controller: _fiatAmountController,
            validator: (_) {
              return widget.validatorFn(_convertedSatoshies(currencyState));              
            },
            style: themeData.dialogTheme.contentTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Text(
                _contentMessage(context, currencyState),
                style: themeData.textTheme.headline5!.copyWith(
                  fontSize: 16.0,
                ),
              ),
              _buildExchangeRateLabel(context, fiatConversion),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(
      BuildContext context, CurrencyState currencyState) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context)!;

    List<Widget> actions = [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          texts.currency_converter_dialog_action_cancel,
          style: themeData.primaryTextTheme.button,
        ),
      ),
    ];

    // Show done button only when the converted amount is bigger than 0
    if (_fiatAmountController.text.isNotEmpty &&
        _convertedSatoshies(currencyState) > 0) {
      actions.add(
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget._onConvert(
                currencyState.bitcoinCurrency.format(
                  _convertedSatoshies(currencyState),
                  includeDisplayName: false,
                  userInput: true,
                ),
              );
              Navigator.pop(context);
            }
          },
          child: Text(
            texts.currency_converter_dialog_action_done,
            style: themeData.primaryTextTheme.button,
          ),
        ),
      );
    }
    return actions;
  }

  String _contentMessage(BuildContext context, CurrencyState currencyState) {
    final amount = _fiatAmountController.text.isNotEmpty
        ? currencyState.bitcoinCurrency.format(
            _convertedSatoshies(currencyState),
            includeDisplayName: false,
          )
        : 0;
    final symbol = currencyState.bitcoinCurrency.tickerSymbol;
    return "$amount $symbol";
  }

  void _updateExchangeLabel(double exchangeRate) {
    if (_exchangeRate != exchangeRate) {
      // Blink exchange rate label when exchange rate changes (also switches between fiat currencies)
      if (!_controller!.isAnimating) {
        _controller!.forward();
      }
      _exchangeRate = exchangeRate;
    }
  }

  Int64 _convertedSatoshies(CurrencyState currencyState) {
    var fiatConversion = FiatConversion(
        currencyState.fiatCurrency!, currencyState.fiatExchangeRate!);
    return _fiatAmountController.text.isNotEmpty
        ? fiatConversion.fiatToSat(
            double.parse(_fiatAmountController.text),
          )
        : Int64(0);
  }

  Widget _buildExchangeRateLabel(
    BuildContext context,
    FiatConversion fiatConversion,
  ) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context)!;

    // Empty string widget is returned so that the dialogs height is not changed when the exchange rate is shown
    return _exchangeRate == null
        ? Text(
            "",
            style: themeData.primaryTextTheme.subtitle2,
          )
        : Text(
            texts.currency_converter_dialog_rate(
              fiatConversion.formatFiat(
                _exchangeRate!,
                removeTrailingZeros: true,
              ),
              fiatConversion.currencyData.shortName,
            ),
            style: themeData.primaryTextTheme.subtitle2!
          );
  }

  void _selectFiatCurrency(String shortName) {
    widget._currencyBloc.setFiatShortName(shortName);
  }
}

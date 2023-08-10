import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/csv_exporter.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class PaymentmentFilterExporter extends StatelessWidget {
  final _log = FimberLog("PaymentmentFilterExporter");
  PaymentmentFilterExporter();

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();
    final themeData = Theme.of(context);

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, account) {
        return Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: PopupMenuButton(
              color: themeData.colorScheme.background,
              icon: Icon(
                Icons.more_vert,
                color: themeData.paymentItemTitleTextStyle.color,
              ),
              padding: EdgeInsets.zero,
              offset: const Offset(12, 24),
              onSelected: _select,
              itemBuilder: (context) => [
                PopupMenuItem(
                  height: 36,
                  value: Choice(() => _exportPayments(context)),
                  child: Text(
                    texts.payments_filter_action_export,
                    style: themeData.textTheme.labelLarge,
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _select(Choice choice) {
    choice.function();
  }

  _exportPayments(BuildContext context) {
    final texts = context.texts();
    final navigator = Navigator.of(context);
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    CsvExporter(accountState.paymentFilters, currencyState.fiatId, accountState.payments)
        .export()
        .then((filePath) {
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
      Share.shareXFiles([XFile(filePath)]);
    }).catchError((err) {
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
      _log.e("Received error: $err");
      showFlushbar(
        context,
        message: texts.payments_filter_action_export_failed,
      );
    });
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}

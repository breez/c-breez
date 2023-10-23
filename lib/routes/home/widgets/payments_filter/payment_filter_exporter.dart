import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/bloc/csv_exporter.dart';
import 'package:c_breez/bloc/currency/currency_bloc.dart';
import 'package:c_breez/theme/theme_provider.dart';
import 'package:c_breez/widgets/flushbar.dart';
import 'package:c_breez/widgets/loader.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class PaymentmentFilterExporter extends StatelessWidget {
  final _log = Logger("PaymentmentFilterExporter");
  final PaymentTypeFilter filter;

  PaymentmentFilterExporter(
    this.filter, {
    super.key,
  });

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

  Future _exportPayments(BuildContext context) async {
    final texts = context.texts();
    final navigator = Navigator.of(context);
    final currencyState = context.read<CurrencyBloc>().state;
    final accountState = context.read<AccountBloc>().state;
    var loaderRoute = createLoaderRoute(context);
    navigator.push(loaderRoute);
    String filePath;

    try {
      if (accountState.paymentFilters.fromTimestamp != null ||
          accountState.paymentFilters.toTimestamp != null) {
        final startDate = DateTime.fromMillisecondsSinceEpoch(accountState.paymentFilters.fromTimestamp!);
        final endDate = DateTime.fromMillisecondsSinceEpoch(accountState.paymentFilters.toTimestamp!);
        filePath = await CsvExporter(filter, currencyState.fiatId, accountState,
                startDate: startDate, endDate: endDate)
            .export();
      } else {
        filePath = await CsvExporter(filter, currencyState.fiatId, accountState).export();
      }
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
      Share.shareXFiles([XFile(filePath)]);
    } catch (error) {
      {
        if (loaderRoute.isActive) {
          navigator.removeRoute(loaderRoute);
        }
        _log.severe("Received error: $error");
        // ignore: use_build_context_synchronously
        showFlushbar(
          context,
          message: texts.payments_filter_action_export_failed,
        );
      }
    } finally {
      if (loaderRoute.isActive) {
        navigator.removeRoute(loaderRoute);
      }
    }
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}

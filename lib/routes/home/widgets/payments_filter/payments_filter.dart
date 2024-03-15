import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payment_filter_exporter.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_calendar.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsFilters extends StatefulWidget {
  const PaymentsFilters({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return PaymentsFilterState();
  }
}

class PaymentsFilterState extends State<PaymentsFilters> {
  String? _filter;
  Map<String, List<PaymentTypeFilter>> _filterMap = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filter = null;
  }

  @override
  Widget build(BuildContext context) {
    final texts = context.texts();

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, account) {
        if (_filter == null) {
          _filterMap = {
            texts.payments_filter_option_all: PaymentTypeFilter.values,
            texts.payments_filter_option_sent: [PaymentTypeFilter.Sent, PaymentTypeFilter.ClosedChannel],
            texts.payments_filter_option_received: [PaymentTypeFilter.Received],
          };
          _filter = _getFilterTypeString(
            context,
            account.paymentFilters.filters,
          );
        }

        return Row(
          children: [
            PaymentmentFilterExporter(_getFilterType()),
            PaymentsFilterCalendar(_getFilterType()),
            PaymentsFilterDropdown(
              _filter!,
              (value) {
                setState(() {
                  _filter = value?.toString();
                });
                final accountBloc = context.read<AccountBloc>();
                accountBloc.changePaymentFilter(
                  filters: _getFilterType(),
                  fromTimestamp: accountBloc.state.paymentFilters.fromTimestamp,
                  toTimestamp: accountBloc.state.paymentFilters.toTimestamp,
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<PaymentTypeFilter> _getFilterType() {
    return _filterMap[_filter] ?? PaymentTypeFilter.values;
  }

  String _getFilterTypeString(
    BuildContext context,
    List<PaymentTypeFilter>? filterType,
  ) {
    for (var entry in _filterMap.entries) {
      if (entry.value == filterType) {
        return entry.key;
      }
    }
    final texts = context.texts();
    return texts.payments_filter_option_all;
  }
}

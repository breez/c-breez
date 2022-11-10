import 'package:breez_sdk/bridge_generated.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_calendar.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentsFilter extends StatefulWidget {
  const PaymentsFilter({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PaymentsFilterState();
  }
}

class PaymentsFilterState extends State<PaymentsFilter> {
  String? _filter;
  Map<String, PaymentTypeFilter> _filterMap = {};

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
        // final payments = account.transactions;

        if (_filter == null) {
          _filterMap = {
            texts.payments_filter_option_all: PaymentTypeFilter.All,
            texts.payments_filter_option_sent: PaymentTypeFilter.Sent,
            texts.payments_filter_option_received: PaymentTypeFilter.Received,
          };
          _filter = _getFilterTypeString(
              context, PaymentTypeFilter.All // payments.filter.paymentType,
              );
        }

        return Row(
          children: [
            PaymentsFilterCalendar(_getFilterType()),
            PaymentsFilterDropdown(
              _filter!,
                  (value) {
                setState(() {
                  _filter = value?.toString();
                });
                final accountBloc = context.read<AccountBloc>();
                accountBloc.changePaymentFilter(
                  filter: _getFilterType(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  PaymentTypeFilter _getFilterType() {
    return _filterMap[_filter] ?? PaymentTypeFilter.All;
  }

  String _getFilterTypeString(
    BuildContext context,
    PaymentTypeFilter filterType,
  ) {
    for (var entry in _filterMap.entries) {
      if (filterType == entry.value) {
        return entry.key;
      }
    }
    final texts = context.texts();
    return texts.payments_filter_option_all;
  }
}
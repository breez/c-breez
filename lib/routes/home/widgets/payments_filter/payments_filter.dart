import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/l10n/build_context_localizations.dart';
import 'package:c_breez/models/payment_type.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_calendar.dart';
import 'package:c_breez/routes/home/widgets/payments_filter/payments_filter_dropdown.dart';
import 'package:flutter/foundation.dart';
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
  Map<String, List<PaymentType>> _filterMap = {};

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
        final payments = account.payments;
        if (_filter == null) {
          _filterMap = {
            texts.payments_filter_option_all: PaymentType.values,
            texts.payments_filter_option_sent: [
              PaymentType.sent,
            ],
            texts.payments_filter_option_received: [
              PaymentType.received,
            ],
          };
          _filter = _getFilterTypeString(
            context,
            payments.filter.paymentType,
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
                  accountBloc.state.payments.filter.copyWith(
                    filter: _getFilterType(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  List<PaymentType> _getFilterType() {
    return _filterMap[_filter] ?? PaymentType.values;
  }

  String _getFilterTypeString(
      BuildContext context,
      List<PaymentType> filterList,
      ) {
    for (var entry in _filterMap.entries) {
      if (listEquals(filterList, entry.value)) {
        return entry.key;
      }
    }
    final texts = context.texts();
    return texts.payments_filter_option_all;
  }
}
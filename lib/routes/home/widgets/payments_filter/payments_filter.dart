import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/bloc/account/account_state.dart';
import 'package:c_breez/models/payment_type.dart';
import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'calendar_dialog.dart';
import 'fixed_sliver_delegate.dart';

class PaymentFilterSliver extends StatefulWidget {
  final ScrollController _controller;
  final double _minSize;
  final double _maxSize;
  final PaymentsState _paymentsModel;

  const PaymentFilterSliver(
    this._controller,
    this._minSize,
    this._maxSize,
    this._paymentsModel,
  );

  @override
  State<StatefulWidget> createState() {
    return PaymentFilterSliverState();
  }
}

class PaymentFilterSliverState extends State<PaymentFilterSliver> {
  @override
  void initState() {
    super.initState();
    widget._controller.addListener(onScroll);
  }

  @override
  void dispose() {
    widget._controller.removeListener(onScroll);
    super.dispose();
  }

  void onScroll() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scrollOffset = widget._controller.position.pixels;
    final filter = widget._paymentsModel.filter;
    final paymentType = filter.paymentType;

    bool hasNoTypeFilter = (paymentType.contains(PaymentType.sent) &&
        paymentType.contains(PaymentType.received));
    bool hasNoDateFilter = (filter.endDate == null);
    bool hasNoFilter = hasNoTypeFilter && hasNoDateFilter;

    return SliverPersistentHeader(
      pinned: true,
      delegate: FixedSliverDelegate(
        !hasNoFilter
            ? widget._maxSize
            : scrollOffset.clamp(
                widget._minSize,
                widget._maxSize,
              ),
        builder: (context, shrinkedHeight, overlapContent) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: !hasNoFilter
                ? 1.0
                : (scrollOffset - widget._maxSize / 2).clamp(0.0, 1.0),
            child: Container(
              color: theme.customData[theme.themeId]!.dashboardBgColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: theme.customData[theme.themeId]!.paymentListBgColor,
                    height: widget._maxSize,
                    child: PaymentsFilter(
                      context.read<AccountBloc>(),
                      widget._paymentsModel,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PaymentsFilter extends StatefulWidget {
  final AccountBloc _accountBloc;
  final PaymentsState _paymentsModel;

  const PaymentsFilter(
    this._accountBloc,
    this._paymentsModel,
  );

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
    final texts = AppLocalizations.of(context)!;

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
        widget._paymentsModel.filter.paymentType,
      );
    }

    return Row(children: [_buildFilterDropdown(context)]);
  }

  Padding _buildCalendarButton(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: IconButton(
        icon: ImageIcon(
          const AssetImage("src/icon/calendar.png"),
          color: themeData.colorScheme.onSecondary,
          size: 24.0,
        ),
        onPressed: () => widget._paymentsModel.firstDate != null
            ? showDialog(
                useRootNavigator: false,
                context: context,
                builder: (_) =>
                    CalendarDialog(widget._paymentsModel.firstDate!),
              ).then((result) {
                widget._accountBloc.changePaymentFilter(
                    widget._accountBloc.state.payments.filter.copyWith(
                        filter: _getFilterType(_filter),
                        startDate: result[0],
                        endDate: result[1]));
              })
            : ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    texts.payments_filter_message_loading_transactions,
                  ),
                ),
              ),
      ),
    );
  }

  Theme _buildFilterDropdown(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return Theme(
      data: themeData.copyWith(
        canvasColor: theme.customData[theme.themeId]!.paymentListBgColor,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            iconEnabledColor: themeData.colorScheme.onSecondary,
            value: _filter,
            style: themeData.textTheme.subtitle2?.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            items: [
              texts.payments_filter_option_all,
              texts.payments_filter_option_sent,
              texts.payments_filter_option_received,
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Material(
                  child: Text(
                    value,
                    style: themeData.textTheme.subtitle2?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _filter = value?.toString();
              });
              widget._accountBloc.changePaymentFilter(
                  widget._accountBloc.state.payments.filter.copyWith(
                filter: _getFilterType(_filter),
              ));
            },
          ),
        ),
      ),
    );
  }

  List<PaymentType> _getFilterType(String? filter) {
    return _filterMap[filter] ?? PaymentType.values;
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
    final texts = AppLocalizations.of(context)!;
    return texts.payments_filter_option_all;
  }

  Padding _buildExportButton(BuildContext context) {
    final themeData = Theme.of(context);
    final texts = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: theme.themeId == "BLUE"
              ? themeData.colorScheme.onSecondary.withOpacity(0.25)
              : themeData.disabledColor,
          size: 24.0,
        ),
        onPressed: null,
      ),
    );
  }
}

class Choice {
  const Choice(this.function);

  final Function function;
}

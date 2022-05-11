import 'dart:async';

import 'package:c_breez/theme/theme_provider.dart' as theme;
import 'package:c_breez/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalendarDialog extends StatefulWidget {
  final DateTime firstDate;

  const CalendarDialog(this.firstDate);

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startDate = widget.firstDate;
    _startDateController.text = BreezDateUtils.formatYearMonthDay(_startDate);
    _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
  }

  @override
  Widget build(BuildContext context) {
    final texts = AppLocalizations.of(context)!;
    final themeData = Theme.of(context);

    return AlertDialog(
      title: Text(
        texts.pos_transactions_range_dialog_title,
        style: themeData.dialogTheme.titleTextStyle,
      ),
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: _selectDateButton(
              texts.pos_transactions_range_dialog_start,
              _startDateController,
              true,
            ),
          ),
          Flexible(
            child: _selectDateButton(
              texts.pos_transactions_range_dialog_end,
              _endDateController,
              false,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            texts.pos_transactions_range_dialog_clear,
            style: theme.cancelButtonStyle.copyWith(
              color:
                  theme.themeId == "BLUE" ? Colors.red : themeData.errorColor,
            ),
          ),
          onPressed: _clearFilter,
        ),
        TextButton(
          child: Text(
            texts.pos_transactions_range_dialog_apply,
            style: themeData.primaryTextTheme.button,
          ),
          onPressed: () => _applyFilter(context),
        ),
      ],
    );
  }

  void _applyFilter(BuildContext context) {
    // Check if filter is unchanged
    final navigator = Navigator.of(context);
    if (_startDate != widget.firstDate || _endDate.day != DateTime.now().day) {
      navigator.pop([
        DateTime(_startDate.year, _startDate.month, _startDate.day, 0, 0, 0),
        DateTime(_endDate.year, _endDate.month, _endDate.day, 23, 59, 59, 999),
      ]);
    } else {
      navigator.pop([null, null]);
    }
  }

  Widget _selectDateButton(
    String label,
    TextEditingController textEditingController,
    bool isStartBtn,
  ) {
    final themeData = Theme.of(context);

    return GestureDetector(
      child: Theme(
        data: theme.themeId == "BLUE"
            ? themeData
            : themeData.copyWith(
                disabledColor: themeData.backgroundColor,
              ),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: themeData.dialogTheme.contentTextStyle,
          ),
          controller: textEditingController,
          enabled: false,
          style: themeData.dialogTheme.contentTextStyle,
        ),
      ),
      onTap: () {
        setState(() {
          _selectDate(context, isStartBtn);
        });
      },
      behavior: HitTestBehavior.translucent,
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartBtn) async {
    // TODO: Show error if end date is earlier than start date or do not allow picking an earlier date at all
    DateTime? selectedDate = await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      context: context,
      initialDate: isStartBtn ? _startDate : _endDate,
      firstDate: widget.firstDate,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: theme.calendarTheme,
          child: child!,
        );
      },
    );
    Duration difference = isStartBtn
        ? selectedDate!.difference(_endDate)
        : selectedDate!.difference(_startDate);
    if (difference.inDays < 0) {
      setState(() {
        isStartBtn ? _startDate = selectedDate : _endDate = selectedDate;
        _startDateController.text =
            BreezDateUtils.formatYearMonthDay(_startDate);
        _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
      });
    } else {
      setState(() {
        if (isStartBtn) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
        _startDateController.text =
            BreezDateUtils.formatYearMonthDay(_startDate);
        _endDateController.text = BreezDateUtils.formatYearMonthDay(_endDate);
      });
    }
  }

  _clearFilter() {
    setState(() {
      _startDate = widget.firstDate;
      _endDate = DateTime.now();
      _startDateController.text = "";
      _endDateController.text = "";
    });
  }
}

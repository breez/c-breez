import 'dart:io';

import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/account_bloc.dart';
import 'package:c_breez/utils/date.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

final _log = Logger("CsvExporter");

class CsvExporter {
  final AccountBloc accountBloc;
  final bool usesUtcTime;
  final String fiatCurrency;
  final DateTime? startDate;
  final DateTime? endDate;

  CsvExporter(
    this.fiatCurrency,
    this.accountBloc, {
    this.usesUtcTime = false,
    this.startDate,
    this.endDate,
  });

  Future<String> export() async {
    _log.info("export payments started");
    String tmpFilePath =
        await _saveCsvFile(const ListToCsvConverter().convert(_generateList() as List<List>));
    _log.info("export payments finished");
    return tmpFilePath;
  }

  List _generateList() {
    // Fetch CurrencyState map values accordingly
    _log.info("generating payment list started");
    final texts = getSystemAppLocalizations();
    final filteredPayments = accountBloc.filterPaymentList();
    List<List<String>> paymentList = List.generate(filteredPayments.length, (index) {
      List<String> paymentItem = [];
      final data = filteredPayments.elementAt(index);
      final paymentInfo = data;
      paymentItem.add(
        BreezDateUtils.formatYearMonthDayHourMinute(
          paymentInfo.paymentTime,
        ),
      );
      paymentItem.add(paymentInfo.title);
      paymentItem.add(paymentInfo.description);
      paymentItem.add(paymentInfo.destinationPubkey);
      paymentItem.add(paymentInfo.amountSat.toString());
      paymentItem.add(paymentInfo.paymentPreimage);
      paymentItem.add(paymentInfo.id);
      paymentItem.add(paymentInfo.feeSat.toString());
      return paymentItem;
    });
    paymentList.insert(0, [
      texts.csv_exporter_date_and_time,
      texts.csv_exporter_title,
      texts.csv_exporter_description,
      texts.csv_exporter_node_id,
      texts.csv_exporter_amount,
      texts.csv_exporter_preimage,
      texts.csv_exporter_tx_hash,
      texts.csv_exporter_fee,
    ]);
    _log.info("generating payment finished");
    return paymentList;
  }

  Future<String> _saveCsvFile(String csv) async {
    _log.info("save breez payments to csv started");
    String filePath = await _createCsvFilePath();
    final file = File(filePath);
    await file.writeAsString(csv);
    _log.info("save breez payments to csv finished");
    return file.path;
  }

  Future<String> _createCsvFilePath() async {
    _log.info("create breez payments path started");
    final directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/BreezPayments';
    filePath = _appendFilterInformation(filePath);
    filePath += ".csv";
    _log.info("create breez payments path finished");
    return filePath;
  }

  String _appendFilterInformation(String filePath) {
    _log.info("add filter information to path started $filePath");
    final paymentTypeFilters = accountBloc.state.paymentFilters.filters;
    if (paymentTypeFilters != null && paymentTypeFilters != PaymentTypeFilter.values) {
      loop:
      for (var filter in paymentTypeFilters) {
        switch (filter) {
          case PaymentTypeFilter.Sent || PaymentTypeFilter.ClosedChannel:
            filePath += "_sent";
            break loop;
          case PaymentTypeFilter.Received:
            filePath += "_received";
            break loop;
        }
      }
    }
    if (startDate != null && endDate != null) {
      DateFormat dateFilterFormat = DateFormat("d.M.yy");
      String dateFilter = '${dateFilterFormat.format(startDate!)}-${dateFilterFormat.format(endDate!)}';
      filePath += "_$dateFilter";
    }
    _log.info("add filter information to path finished");
    return filePath;
  }
}

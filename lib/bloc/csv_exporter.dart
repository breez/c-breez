import 'dart:io';

import 'package:breez_translations/breez_translations_locales.dart';
import 'package:c_breez/bloc/account/payment_filters.dart';
import 'package:c_breez/models/payment_minutiae.dart';
import 'package:c_breez/utils/date.dart';
import 'package:csv/csv.dart';
import 'package:fimber/fimber.dart';
import 'package:path_provider/path_provider.dart';

final _log = FimberLog("CsvExporter");

class CsvExporter {
  final List<PaymentMinutiae> data;
  final bool usesUtcTime;
  final String fiatCurrency;
  final PaymentFilters filter;

  CsvExporter(
    this.filter,
    this.fiatCurrency,
    this.data, {
    this.usesUtcTime = false,
  });

  Future<String> export() async {
    _log.i("export payments started");
    String tmpFilePath =
        await _saveCsvFile(const ListToCsvConverter().convert(_generateList() as List<List>));
    _log.i("export payments finished");
    return tmpFilePath;
  }

  List _generateList() {
    // fetch currencystate map values accordingly
    _log.i("generating payment list started");

    final texts = getSystemAppLocalizations();

    List<List<String>> paymentList = List.generate(data.length, (index) {
      List<String> paymentItem = [];
      final data = this.data.elementAt(index);
      final paymentInfo = data;
      paymentItem.add(
        BreezDateUtils.formatYearMonthDayHourMinute(
          paymentInfo.paymentTime,
        ),
      );
      paymentItem.add(paymentInfo.title);
      paymentItem.add(paymentInfo.description);
      paymentItem.add(paymentInfo.destinationPubkey);
      paymentItem.add(paymentInfo.id);
      paymentItem.add(paymentInfo.amountSat.toString());
      paymentItem.add(paymentInfo.paymentPreimage);
      paymentItem.add(paymentInfo.lnAddress);
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
      fiatCurrency,
    ]);
    _log.i("generating payment finished");
    return paymentList;
  }

  Future<String> _saveCsvFile(String csv) async {
    _log.i("save breez payments to csv started");
    String filePath = await _createCsvFilePath();
    final file = File(filePath);
    await file.writeAsString(csv);
    _log.i("save breez payments to csv finished");
    return file.path;
  }

  Future<String> _createCsvFilePath() async {
    _log.i("create breez payments path started");
    final directory = await getTemporaryDirectory();
    String filePath = '${directory.path}/BreezPayments';
    filePath = _appendFilterInformation(filePath);
    filePath += ".csv";
    _log.i("create breez payments path finished");
    return filePath;
  }

  String _appendFilterInformation(String filePath) {
    _log.i("add filter information to path started");

    _log.i("add filter information to path finished");
    return filePath;
  }
}

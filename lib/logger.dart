library breez.logger;

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final _log = Logger("logger");

void shareLog() async {
  final appDir = await getApplicationDocumentsDirectory();
  final encoder = ZipFileEncoder();
  final zipFilePath = "${appDir.path}/c-breez.logs.zip";
  encoder.create(zipFilePath);
  encoder.addDirectory(Directory("${appDir.path}/logs/"));
  encoder.close();
  final zipFile = XFile(zipFilePath);
  Share.shareXFiles([zipFile]);
}

class BreezLogger {
  BreezLogger() {
    Logger.root.level = Level.ALL;

    if (kDebugMode) {
      Logger.root.onRecord.listen((record) {
        print(_recordToString(record));
      });
    }

    getApplicationDocumentsDirectory().then((appDir) {
      _pruneLogs(appDir);
      final file = File("${_logDir(appDir)}/${DateTime.now().millisecondsSinceEpoch}.log");
      try {
        file.createSync(recursive: true);
      } catch (e) {
        _log.severe("Failed to create log file", e);
        return;
      }
      final sync = file.openWrite(mode: FileMode.append);
      Logger.root.onRecord.listen((record) {
        sync.writeln(_recordToString(record));
      }, onDone: () {
        sync.flush();
        sync.close();
      });
    });

    FlutterError.onError = (FlutterErrorDetails details) async {
      FlutterError.presentError(details);
      final name = details.context?.name ?? "FlutterError";
      final exception = details.exceptionAsString();
      _log.severe("$exception -- $name", details, details.stack);
    };
  }

  String _recordToString(LogRecord record) =>
      "[${record.loggerName}] {${record.level.name}} (${record.time}) : ${record.message}";

  String _logDir(Directory appDir) => "${appDir.path}/logs/";

  void _pruneLogs(Directory appDir) {
    final loggingFolder = Directory(_logDir(appDir));
    if (loggingFolder.existsSync()) {
      // Get and sort log files by modified date
      List<FileSystemEntity> filesToBePruned = loggingFolder
          .listSync(followLinks: false)
          .where((e) => e.path.endsWith('.log'))
          .toList()
        ..sort((l, r) => l.statSync().modified.compareTo(r.statSync().modified));
      // Delete all except last 10 logs
      if (filesToBePruned.length > 10) {
        filesToBePruned.removeRange(
          filesToBePruned.length - 10,
          filesToBePruned.length,
        );
        for (var logFile in filesToBePruned) {
          logFile.delete();
        }
      }
    }
  }
}

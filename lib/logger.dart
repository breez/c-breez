library breez.logger;

import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fimber_io/fimber_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

final _log = FimberLog("logger");

Future<File> get _logFile async {
  final appDir = await getApplicationDocumentsDirectory();
  final logFile = File("${appDir.path}/c-breez.log");
  if (!logFile.existsSync()) {
    logFile.createSync();
  }
  return logFile;
}

void shareLog() async {
  final appDir = await getApplicationDocumentsDirectory();
  final logFile = await _logFile;
  final encoder = ZipFileEncoder();
  final zipFilePath = "${appDir.path}/c-breez.log.zip";
  encoder.create(zipFilePath);
  encoder.addFile(logFile);
  encoder.close();
  ShareExtend.share(zipFilePath, "file");
}

class BreezLogger {
  BreezLogger() {
    final logLevels = [
      "V", // log.v Verbose
      "D", // log.d Debug
      "I", // log.i Info
      "W", // log.w Warning
      "E", // log.e Error
    ];

    if (kDebugMode) {
      Fimber.plantTree(DebugTree.elapsed(
        logLevels: logLevels,
      ));
    }

    _logFile.then((file) {
      final tokens = [
        CustomFormatTree.timeStampToken,
        CustomFormatTree.levelToken,
        CustomFormatTree.tagToken,
        CustomFormatTree.messageToken,
      ];
      Fimber.plantTree(FimberFileTree(
        file.path,
        logLevels: logLevels,
        logFormat: tokens.fold("", (p, e) => p == "" ? e : "$p :: $e"),
      ));
    });

    FlutterError.onError = (FlutterErrorDetails details) async {
      FlutterError.presentError(details);
      final name = details.context?.name ?? "FlutterError";
      final exception = details.exceptionAsString();
      _log.e("$exception --$name", ex: details, stacktrace: details.stack);
    };
  }
}

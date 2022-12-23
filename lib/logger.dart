library breez.logger;

import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fimber_io/fimber_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

final _log = FimberLog("logger");

void shareLog() async {
  final appDir = await getApplicationDocumentsDirectory();
  final encoder = ZipFileEncoder();
  final zipFilePath = "${appDir.path}/c-breez.logs.zip";
  encoder.create(zipFilePath);
  encoder.addDirectory(Directory("${appDir.path}/logs/"));
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

    getApplicationDocumentsDirectory().then(
      (appDir) {
        final tokens = [
          CustomFormatTree.timeStampToken,
          CustomFormatTree.levelToken,
          CustomFormatTree.tagToken,
          CustomFormatTree.messageToken,
        ];
        Fimber.plantTree(
          SizeRollingFileTree(
            DataSize(megabytes: 2),
            filenamePrefix: "${appDir.path}/logs/c_breez.",
            filenamePostfix: ".log",
            logLevels: logLevels,
            logFormat: tokens.fold("", (p, e) => p == "" ? e : "$p :: $e"),
          ),
        );
        FlutterError.onError = (FlutterErrorDetails details) async {
          FlutterError.presentError(details);
          final name = details.context?.name ?? "FlutterError";
          final exception = details.exceptionAsString();
          _log.e("$exception --$name", ex: details, stacktrace: details.stack);
        };
      },
    );
  }
}

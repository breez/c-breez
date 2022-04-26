library breez.logger;

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

final Logger log = Logger('c-breez');

Future<File> get _logFile async {
  var appDir = await getApplicationDocumentsDirectory();
  var logFile = File(appDir.path + "/log.txt");
  if (!logFile.existsSync()) {
    logFile.createSync();
  }
  return logFile;
}

void shareLog() {
  _logFile.then((file) {
    ShareExtend.share(file.path, "file");
  });
}

Future shareFile(String filePath) {
  return ShareExtend.share(filePath, "file");
}

class BreezLogger {
  BreezLogger() {    
    // Log flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details == null) {
        print("Ignore log, details is null");
        return;
      }
      FlutterError.presentError(details);
      final stack = details.stack?.toString() ?? "NoStack";
      final name = details.context?.name ?? "FlutterError";
      final exception = details.exceptionAsString();      
      print(exception + '\n' + stack + " --" + name);
    };
  }
}

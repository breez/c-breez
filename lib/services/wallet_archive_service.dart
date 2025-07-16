import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:c_breez/bloc/account/credentials_manager.dart';
import 'package:c_breez/configs/config.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'injector.dart';

final Logger _logger = Logger('WalletArchiveService');

/// Service responsible for creating archive files of wallet data and application logs
class WalletArchiveService {
  /// Private constructor to prevent instantiation
  WalletArchiveService._();

  /// Default name for logs archive file
  static const String _logsArchiveFilename = 'c-breez.logs.zip';

  /// Default name for keys archive file
  static const String _keysArchiveFilename = 'c-breez.keys.zip';

  /// Gets the current AppConfig instance
  static Future<Config> _getAppConfig() async {
    try {
      return await Config.instance();
    } catch (e) {
      _logger.severe('Failed to get AppConfig: $e');
      rethrow;
    }
  }

  /// Gets the path to the logs directory
  static Future<String> _getLogsDirectory() async {
    final Config config = await _getAppConfig();
    return '${config.sdkConfig.workingDir}/logs/';
  }

  /// Gets the path to the storage file of a wallet
  static Future<String> _getStorageFilePath() async {
    final Config config = await _getAppConfig();
    final String workingDir = config.sdkConfig.workingDir;

    return '$workingDir/storage.sql';
  }

  /// Creates an archive containing application logs
  ///
  /// Returns the path to the created zip file
  static Future<String> createLogsArchive() async {
    _logger.info('Creating logs archive...');

    final Config config = await _getAppConfig();
    final String workingDir = config.sdkConfig.workingDir;
    final String zipFilePath = '$workingDir/$_logsArchiveFilename';
    final ZipFileEncoder encoder = ZipFileEncoder();

    try {
      encoder.create(zipFilePath);
      final String logsDirPath = await _getLogsDirectory();
      final Directory logsDir = Directory(logsDirPath);

      if (await logsDir.exists()) {
        _logger.info('Adding logs from: ${logsDir.path}');
        await encoder.addDirectory(logsDir);
      } else {
        _logger.warning('Logs directory not found: ${logsDir.path}');
        _logger.info('Creating logs directory: ${logsDir.path}');
        await logsDir.create(recursive: true);
      }
      await encoder.close();
      _logger.info('Logs archive created at: $zipFilePath');
      return zipFilePath;
    } catch (e) {
      _logger.severe('Failed to create logs archive: $e');
      // Ensure encoder is closed even on error
      try {
        await encoder.close();
      } catch (closeError) {
        _logger.warning('Error closing zip encoder: $closeError');
      }
      rethrow;
    }
  }

  /// Creates an archive containing wallet keys and storage DB
  ///
  /// Returns the path to the created zip file
  static Future<String> createKeysArchive() async {
    _logger.info('Creating keys archive for wallet.');

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String zipFilePath = '${appDir.path}/$_keysArchiveFilename';
    final ZipFileEncoder encoder = ZipFileEncoder();

    try {
      encoder.create(zipFilePath);

      await Future.wait(<Future<void>>[_addCredentialsToZip(encoder), _addStorageFileToZip(encoder)]);

      await encoder.close();
      _logger.info('Keys archive created at: $zipFilePath');
      return zipFilePath;
    } catch (e) {
      _logger.severe('Failed to create keys archive: $e');
      // Ensure encoder is closed even on error
      try {
        await encoder.close();
      } catch (closeError) {
        _logger.warning('Error closing zip encoder: $closeError');
      }
      rethrow;
    }
  }

  /// Adds credential files to the zip archive
  ///
  /// [encoder] The zip encoder to which files will be added
  static Future<void> _addCredentialsToZip(ZipFileEncoder encoder) async {
    final CredentialsManager credentialsManager = ServiceInjector().credentialsManager;

    try {
      final List<File> credentialFiles = await credentialsManager.exportCredentials();
      _logger.info('Adding ${credentialFiles.length} credential files to zip');

      for (File file in credentialFiles) {
        try {
          final Uint8List bytes = await file.readAsBytes();
          final String filename = basename(file.path);
          encoder.addArchiveFile(ArchiveFile(filename, bytes.length, bytes));
          _logger.fine('Added credential file: $filename');
        } catch (e) {
          _logger.warning('Failed to add ${file.path}: $e');
          // Continue with other files even if one fails
        }
      }
    } catch (e) {
      _logger.severe('Failed to export credentials: $e');
      rethrow;
    }
  }

  /// Adds the wallet storage file to the zip archive
  ///
  /// [encoder] The zip encoder to which the file will be added
  static Future<void> _addStorageFileToZip(ZipFileEncoder encoder) async {
    final String storageFilePath = await _getStorageFilePath();
    _logger.info('Adding storage file: $storageFilePath');

    final File storageFile = File(storageFilePath);
    if (await storageFile.exists()) {
      await encoder.addFile(storageFile);
      _logger.fine('Storage file added to archive');
    } else {
      _logger.warning('Storage file not found: $storageFilePath');
      // We don't throw here, as the credentials might still be useful
    }
  }

  /// Deletes all contents inside sdkConfig.workingDir without deleting the logs & directory itself
  static Future<void> clearWorkingDirContents() async {
    final Config config = await _getAppConfig();
    final String workingDirPath = config.sdkConfig.workingDir;
    final Directory workingDir = Directory(workingDirPath);
    final String logsDirPath = path.join(workingDirPath, 'logs');

    try {
      if (await workingDir.exists()) {
        _logger.info('Clearing contents of workingDir at: $workingDirPath');
        final List<FileSystemEntity> contents = workingDir.listSync();
        for (final entity in contents) {
          if (path.equals(entity.path, logsDirPath)) continue;
          await entity.delete(recursive: true);
        }
        _logger.info('Contents of workingDir cleared successfully');
      } else {
        _logger.warning('workingDir not found: $workingDirPath');
      }
    } catch (e) {
      _logger.severe('Failed to clear workingDir contents: $e');
      rethrow;
    }
  }
}

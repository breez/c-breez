import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:logging/logging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class BackupBloc extends Cubit<BackupState?> {
  final _log = Logger("BackupBloc");
  final BreezSDK _breezLib;

  BackupBloc(this._breezLib) : super(null) {
    _listenBackupEvents();
  }

  _listenBackupEvents() {
    _log.fine("_listenBackupEvents");
    _breezLib.backupStream.listen((event) {
      _log.info('got state: $event');
      if (event is sdk.BreezEvent_BackupStarted) {
        emit(BackupState(status: BackupStatus.INPROGRESS));
      }
      if (event is sdk.BreezEvent_BackupSucceeded) {
        _log.info("BreezEvent_BackupSucceeded, backupbloc");
        emit(BackupState(status: BackupStatus.SUCCESS));
      }
      if (event is sdk.BreezEvent_BackupFailed) {
        _log.info("BreezEvent_BackupFailed");
        emit(BackupState(status: BackupStatus.FAILED));
      }
    }, onError: (error) {
      emit(BackupState(status: BackupStatus.FAILED));
    });
  }

  /// Start the backup process
  Future<void> backup() async => await _breezLib.backup();
}

import 'package:breez_sdk/breez_sdk.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

class BackupBloc extends Cubit<BackupState?> {
  final _log = Logger("BackupBloc");
  final BreezSDK _breezSDK;

  BackupBloc(this._breezSDK) : super(null) {
    _listenBackupEvents();
  }

  void _listenBackupEvents() {
    _log.info("_listenBackupEvents");
    _breezSDK.backupStream.listen(
      (event) {
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
      },
      onError: (error) {
        emit(BackupState(status: BackupStatus.FAILED));
      },
    );
  }

  /// Start the backup process
  Future<void> backup() async => await _breezSDK.backup();
}

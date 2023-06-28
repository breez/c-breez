import 'package:breez_sdk/breez_bridge.dart';
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;

class BackupBloc extends Cubit<BackupState?> {
  final _log = FimberLog("BackupBloc");
  final BreezBridge _breezLib;

  BackupBloc(this._breezLib) : super(null) {
    _listenBackupEvents();
  }

  _listenBackupEvents() {
    _log.v("_listenBackupEvents");
    _breezLib.backupStream.listen((event) {
      _log.i('got state: $event');
      if (event is sdk.BreezEvent_BackupStarted) {
        emit(BackupState(status: BackupStatus.INPROGRESS));
      }
      if (event is sdk.BreezEvent_BackupSucceeded) {
        _log.i("BreezEvent_BackupSucceeded, backupbloc");
        emit(BackupState(status: BackupStatus.SUCCESS));
      }
      if (event is sdk.BreezEvent_BackupFailed) {
        _log.i("BreezEvent_BackupFailed");
        emit(BackupState(status: BackupStatus.FAILED));
      }
    }, onError: (error) {
      emit(BackupState(status: BackupStatus.FAILED));
    });
  }
}

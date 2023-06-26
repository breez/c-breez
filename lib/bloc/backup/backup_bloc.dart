import 'dart:async';
import 'package:breez_sdk/breez_bridge.dart' as bridge;
import 'package:c_breez/bloc/backup/backup_state.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:breez_sdk/bridge_generated.dart' as sdk;

class BackupBloc extends Cubit<BackupState?> {
  final _log = FimberLog("BackupBloc");
  final bridge.BreezBridge _breezBridge;

  final StreamController<BackupState> _backupStreamController = StreamController<BackupState>();

  Stream<BackupState> get backupStream => _backupStreamController.stream;

  BackupBloc(this._breezBridge) : super(null) {
    _listenBackupEvents();
  }

  _listenBackupEvents() {
    _log.v("_listenBackupEvents");
    _breezBridge.backupStream.listen((state) {
      if (state is sdk.BreezEvent_BackupStarted) {
        _log.i("BreezEvent_BackupStarted");
        _backupStreamController.add(BackupState(status: BackupStatus.INPROGRESS));
      }
      if (state is sdk.BreezEvent_BackupSucceeded) {
        _log.i("BreezEvent_BackupSucceeded, backupbloc");
        _backupStreamController.add(BackupState(status: BackupStatus.SUCCESS));
      }
      if (state is sdk.BreezEvent_BackupFailed) {
        _log.i("BreezEvent_BackupFailed");
        _backupStreamController.add(BackupState(status: BackupStatus.FAILED));
      }
    }, onError: (error) {
      _backupStreamController.add(BackupState(status: BackupStatus.FAILED));
    });
  }
}

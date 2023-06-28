enum BackupStatus { FAILED, SUCCESS, INPROGRESS }

class BackupState {
  final BackupStatus status;

  BackupState({required this.status});
}

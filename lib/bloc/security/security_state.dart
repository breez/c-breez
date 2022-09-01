const _kDefaultLockInterval = 120;

class SecurityState {
  final PinStatus pinStatus;
  final Duration lockInterval;

  const SecurityState(
    this.pinStatus,
    this.lockInterval,
  );

  const SecurityState.initial()
      : this(
          PinStatus.initial,
          const Duration(seconds: _kDefaultLockInterval),
        );

  SecurityState copyWith({
    PinStatus? pinStatus,
    Duration? lockInterval,
  }) {
    return SecurityState(
      pinStatus ?? this.pinStatus,
      lockInterval ?? this.lockInterval,
    );
  }

  SecurityState.fromJson(Map<String, dynamic> json)
      : pinStatus = PinStatus.values.byName(json["pinStatus"] ?? PinStatus.initial.name),
        lockInterval = Duration(seconds: json["lockInterval"] ?? _kDefaultLockInterval);

  Map<String, dynamic> toJson() => {
        "pinStatus": pinStatus.name,
        "lockInterval": lockInterval.inSeconds,
      };
}

enum PinStatus {
  initial,
  enabled,
  disabled,
}

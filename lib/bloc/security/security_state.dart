const _kDefaultLockInterval = 120;

class SecurityState {
  final PinStatus pinStatus;
  final Duration lockInterval;
  final LocalAuthenticationOption localAuthenticationOption;

  const SecurityState(
    this.pinStatus,
    this.lockInterval,
    this.localAuthenticationOption,
  );

  const SecurityState.initial()
      : this(
          PinStatus.initial,
          const Duration(seconds: _kDefaultLockInterval),
          LocalAuthenticationOption.none,
        );

  SecurityState copyWith({
    PinStatus? pinStatus,
    Duration? lockInterval,
    LocalAuthenticationOption? localAuthenticationOption,
  }) {
    return SecurityState(
      pinStatus ?? this.pinStatus,
      lockInterval ?? this.lockInterval,
      localAuthenticationOption ?? this.localAuthenticationOption,
    );
  }

  SecurityState.fromJson(Map<String, dynamic> json)
      : pinStatus = PinStatus.values.byName(json["pinStatus"] ?? PinStatus.initial.name),
        lockInterval = Duration(seconds: json["lockInterval"] ?? _kDefaultLockInterval),
        localAuthenticationOption = LocalAuthenticationOption.values
            .byName(json["localAuthenticationOption"] ?? LocalAuthenticationOption.none.name);

  Map<String, dynamic> toJson() => {
        "pinStatus": pinStatus.name,
        "lockInterval": lockInterval.inSeconds,
        "localAuthenticationOption": localAuthenticationOption.name,
      };
}

enum PinStatus {
  initial,
  enabled,
  disabled,
}

enum LocalAuthenticationOption {
  face,
  faceId,
  fingerprint,
  touchId,
  other,
  none,
}

extension LocalAuthenticationOptionExtension on LocalAuthenticationOption {
  bool get isFacial => this == LocalAuthenticationOption.face || this == LocalAuthenticationOption.faceId;

  bool get isFingerprint => this == LocalAuthenticationOption.fingerprint || this == LocalAuthenticationOption.touchId;

  bool get isOtherBiometric => this == LocalAuthenticationOption.other;
}

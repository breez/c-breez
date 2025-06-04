import 'dart:convert';

/// Default auto-lock timeout in seconds
const _kDefaultLockTimeout = 120;

/// Represents the status of PIN protection in the app
enum PinStatus {
  /// Initial state before user sets any preference
  initial,

  /// PIN protection is active
  enabled,

  /// PIN protection is explicitly disabled
  disabled,
}

/// Represents the type of biometric authentication available on the device
enum BiometricType {
  /// Generic face recognition (Android)
  face,

  /// Apple Face ID
  faceId,

  /// Generic fingerprint recognition (Android)
  fingerprint,

  /// Apple Touch ID
  touchId,

  /// Other biometric method not specifically categorized
  other,

  /// No biometric authentication available or disabled
  none,
}

/// Extension to provide helper methods for BiometricType
extension BiometricTypeExtension on BiometricType {
  /// Whether this is a facial recognition method (Face ID or generic face)
  bool get isFacial => this == BiometricType.face || this == BiometricType.faceId;

  /// Whether this is a fingerprint recognition method (Touch ID or generic fingerprint)
  bool get isFingerprint => this == BiometricType.fingerprint || this == BiometricType.touchId;

  /// Whether this is an uncategorized biometric method
  bool get isOtherBiometric => this == BiometricType.other;

  /// Whether any biometric method is available
  bool get isAvailable => this != BiometricType.none;
}

/// Represents the current lock state of the app
enum LockState {
  /// Initial state before any user interaction
  initial,

  /// App is locked and requires authentication
  locked,

  /// App is unlocked and accessible
  unlocked,
}

/// Represents whether the user has verified their recovery phrase/mnemonic
enum MnemonicStatus {
  /// Initial state before verification check
  initial,

  /// User has verified their recovery phrase
  verified,

  /// User has not yet verified their recovery phrase
  unverified,
}

/// Represents the complete security state of the application
class SecurityState {
  /// Current PIN protection status
  final PinStatus pinStatus;

  /// Time after which the app auto-locks when in background
  final Duration lockInterval;

  /// Type of biometric authentication available/enabled
  final BiometricType localAuthenticationOption;

  /// Current lock state of the app
  final LockState lockState;

  /// Recovery phrase verification status
  final MnemonicStatus mnemonicStatus;

  /// Creates a new SecurityState
  ///
  /// [pinStatus] Current PIN protection status
  /// [lockInterval] Time after which app auto-locks when in background
  /// [localAuthenticationOption] Type of biometric authentication available/enabled
  /// [lockState] Current lock state of the app
  /// [mnemonicStatus] Recovery phrase verification status
  const SecurityState({
    required this.pinStatus,
    required this.lockInterval,
    required this.localAuthenticationOption,
    required this.lockState,
    required this.mnemonicStatus,
  });

  /// Creates a default initial state
  const SecurityState.initial()
    : this(
        pinStatus: PinStatus.initial,
        lockInterval: const Duration(seconds: _kDefaultLockTimeout),
        localAuthenticationOption: BiometricType.none,
        lockState: LockState.initial,
        mnemonicStatus: MnemonicStatus.initial,
      );

  /// Creates a new SecurityState with specified fields updated
  SecurityState copyWith({
    PinStatus? pinStatus,
    Duration? lockInterval,
    BiometricType? localAuthenticationOption,
    LockState? lockState,
    MnemonicStatus? mnemonicStatus,
  }) {
    return SecurityState(
      pinStatus: pinStatus ?? this.pinStatus,
      lockInterval: lockInterval ?? this.lockInterval,
      localAuthenticationOption: localAuthenticationOption ?? this.localAuthenticationOption,
      lockState: lockState ?? this.lockState,
      mnemonicStatus: mnemonicStatus ?? this.mnemonicStatus,
    );
  }

  SecurityState.fromJson(Map<String, dynamic> json)
    : pinStatus = PinStatus.values.byName(json["pinStatus"] ?? PinStatus.initial.name),
      lockInterval = Duration(seconds: json["lockInterval"] ?? _kDefaultLockTimeout),
      localAuthenticationOption = BiometricType.values.byName(
        json["localAuthenticationOption"] ?? BiometricType.none.name,
      ),
      lockState = LockState.values.byName(json["lockState"] ?? LockState.unlocked.name),
      mnemonicStatus = MnemonicStatus.values.byName(json["mnemonicStatus"] ?? MnemonicStatus.unverified.name);

  Map<String, dynamic> toJson() => {
    "pinStatus": pinStatus.name,
    "lockInterval": lockInterval.inSeconds,
    "localAuthenticationOption": localAuthenticationOption.name,
    "lockState": lockState.name,
    "mnemonicStatus": mnemonicStatus.name,
  };

  @override
  String toString() => jsonEncode(toJson());

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SecurityState &&
        other.pinStatus == pinStatus &&
        other.lockInterval == lockInterval &&
        other.localAuthenticationOption == localAuthenticationOption &&
        other.lockState == lockState &&
        other.mnemonicStatus == mnemonicStatus;
  }

  @override
  int get hashCode =>
      Object.hash(pinStatus, lockInterval, localAuthenticationOption, lockState, mnemonicStatus);
}

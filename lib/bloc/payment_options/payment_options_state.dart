import 'package:c_breez/utils/preferences.dart';

class PaymentOptionsState {
  final bool overrideFeeEnabled;
  final double proportionalFee;
  final bool saveEnabled;

  const PaymentOptionsState({
    this.overrideFeeEnabled = kDefaultOverrideFee,
    this.proportionalFee = kDefaultProportionalFee,
    this.saveEnabled = false,
  });

  const PaymentOptionsState.initial() : this();

  PaymentOptionsState copyWith({
    bool? overrideFeeEnabled,
    double? proportionalFee,
    bool? saveEnabled,
  }) {
    return PaymentOptionsState(
      overrideFeeEnabled: overrideFeeEnabled ?? this.overrideFeeEnabled,
      proportionalFee: proportionalFee ?? this.proportionalFee,
      saveEnabled: saveEnabled ?? this.saveEnabled,
    );
  }

  @override
  String toString() => 'PaymentOptionsState{overrideFeeEnabled: $overrideFeeEnabled, '
      'proportionalFee: $proportionalFee, saveEnabled: $saveEnabled}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentOptionsState &&
          runtimeType == other.runtimeType &&
          overrideFeeEnabled == other.overrideFeeEnabled &&
          proportionalFee == other.proportionalFee &&
          saveEnabled == other.saveEnabled;

  @override
  int get hashCode =>
      overrideFeeEnabled.hashCode ^ proportionalFee.hashCode ^ saveEnabled.hashCode;
}

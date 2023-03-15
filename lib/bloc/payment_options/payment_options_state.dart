import 'package:c_breez/utils/preferences.dart';

class PaymentOptionsState {
  final bool overrideFeeEnabled;
  final int baseFee;
  final double proportionalFee;
  final bool saveEnabled;

  const PaymentOptionsState({
    this.overrideFeeEnabled = kDefaultOverrideFee,
    this.baseFee = kDefaultBaseFee,
    this.proportionalFee = kDefaultProportionalFee,
    this.saveEnabled = false,
  });

  const PaymentOptionsState.initial() : this();

  PaymentOptionsState copyWith({
    bool? overrideFeeEnabled,
    int? baseFee,
    double? proportionalFee,
    bool? saveEnabled,
  }) {
    return PaymentOptionsState(
      overrideFeeEnabled: overrideFeeEnabled ?? this.overrideFeeEnabled,
      baseFee: baseFee ?? this.baseFee,
      proportionalFee: proportionalFee ?? this.proportionalFee,
      saveEnabled: saveEnabled ?? this.saveEnabled,
    );
  }

  @override
  String toString() => 'PaymentOptionsState{overrideFeeEnabled: $overrideFeeEnabled, baseFee: $baseFee, '
      'proportionalFee: $proportionalFee, saveEnabled: $saveEnabled}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentOptionsState &&
          runtimeType == other.runtimeType &&
          overrideFeeEnabled == other.overrideFeeEnabled &&
          baseFee == other.baseFee &&
          proportionalFee == other.proportionalFee &&
          saveEnabled == other.saveEnabled;

  @override
  int get hashCode =>
      overrideFeeEnabled.hashCode ^ baseFee.hashCode ^ proportionalFee.hashCode ^ saveEnabled.hashCode;
}

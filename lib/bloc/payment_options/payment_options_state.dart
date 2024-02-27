import 'package:c_breez/utils/preferences.dart';

class PaymentOptionsState {
  final double proportionalFee;
  final int exemptFeeMsat;
  final int autoChannelSetupFeeLimitMsat;
  final bool saveEnabled;

  const PaymentOptionsState({
    this.proportionalFee = kDefaultProportionalFee,
    this.exemptFeeMsat = kDefaultExemptFeeMsat,
    this.autoChannelSetupFeeLimitMsat = kDefaultAutoChannelSetupFeeLimitMsat,
    this.saveEnabled = false,
  });

  const PaymentOptionsState.initial() : this();

  PaymentOptionsState copyWith({
    double? proportionalFee,
    int? exemptFeeMsat,
    int? autoChannelSetupFeeLimitMsat,
    bool? saveEnabled,
  }) {
    return PaymentOptionsState(
      proportionalFee: proportionalFee ?? this.proportionalFee,
      exemptFeeMsat: exemptFeeMsat ?? this.exemptFeeMsat,
      autoChannelSetupFeeLimitMsat: autoChannelSetupFeeLimitMsat ?? this.autoChannelSetupFeeLimitMsat,
      saveEnabled: saveEnabled ?? this.saveEnabled,
    );
  }

  @override
  String toString() =>
      'PaymentOptionsState{proportionalFee: $proportionalFee, saveEnabled: $saveEnabled, exemptFeeMsat: $exemptFeeMsat}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentOptionsState &&
          runtimeType == other.runtimeType &&
          proportionalFee == other.proportionalFee &&
          exemptFeeMsat == other.exemptFeeMsat &&
          saveEnabled == other.saveEnabled;

  @override
  int get hashCode => proportionalFee.hashCode ^ saveEnabled.hashCode ^ exemptFeeMsat.hashCode;
}

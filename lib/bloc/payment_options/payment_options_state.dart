import 'package:c_breez/utils/preferences.dart';

class PaymentOptionsState {
  final double proportionalFee;
  final int exemptFeeMsat;
  final int channelFeeLimitMsat;

  const PaymentOptionsState({
    this.proportionalFee = kDefaultProportionalFee,
    this.exemptFeeMsat = kDefaultExemptFeeMsat,
    this.channelFeeLimitMsat = kDefaultChannelSetupFeeLimitMsat,
  });

  const PaymentOptionsState.initial() : this();

  PaymentOptionsState copyWith({
    double? proportionalFee,
    int? exemptFeeMsat,
    int? channelFeeLimitMsat,
  }) {
    return PaymentOptionsState(
      proportionalFee: proportionalFee ?? this.proportionalFee,
      exemptFeeMsat: exemptFeeMsat ?? this.exemptFeeMsat,
      channelFeeLimitMsat: channelFeeLimitMsat ?? this.channelFeeLimitMsat,
    );
  }

  @override
  String toString() =>
      'PaymentOptionsState{proportionalFee: $proportionalFee, exemptFeeMsat: $exemptFeeMsat, channelFeeLimitMsat: $channelFeeLimitMsat}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentOptionsState &&
          runtimeType == other.runtimeType &&
          proportionalFee == other.proportionalFee &&
          exemptFeeMsat == other.exemptFeeMsat &&
          channelFeeLimitMsat == other.channelFeeLimitMsat;

  @override
  int get hashCode => proportionalFee.hashCode ^ exemptFeeMsat.hashCode ^ channelFeeLimitMsat.hashCode;
}

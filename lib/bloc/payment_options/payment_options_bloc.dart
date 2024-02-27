import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("PaymentOptionsBloc");

class PaymentOptionsBloc extends Cubit<PaymentOptionsState> {
  final Preferences _preferences;

  PaymentOptionsBloc(
    this._preferences,
  ) : super(const PaymentOptionsState.initial()) {
    _fetchPaymentsOverrideSettings().then((_) => _log.info("Initial settings read"));
  }

  Future<void> setProportionalFee(double proportionalFee) async {
    emit(state.copyWith(proportionalFee: proportionalFee, saveEnabled: true));
  }

  Future<void> setExemptfeeMsat(int exemptFeeMsat) async {
    emit(state.copyWith(exemptFeeMsat: exemptFeeMsat, saveEnabled: true));
  }

  Future<void> setChannelSetupFeeLimitMsat(int channelFeeLimitMsat) async {
    emit(state.copyWith(channelFeeLimitMsat: channelFeeLimitMsat, saveEnabled: true));
  }

  Future<void> resetFees() async {
    _log.info("Resetting payments override settings to default: enabled: $kDefaultOverrideFee, "
        "proportional: $kDefaultProportionalFee");
    await _preferences.setPaymentOptionsProportionalFee(kDefaultProportionalFee);
    await _preferences.setPaymentOptionsExemptFee(kDefaultExemptFeeMsat);
    await _preferences.setPaymentOptionsChannelSetupFeeLimit(kDefaultChannelSetupFeeLimitMsat);
    emit(const PaymentOptionsState.initial());
  }

  Future<void> saveFees() async {
    final state = this.state;
    _log.info(
      "Saving payments override settings: proportionalFee: ${state.proportionalFee} "
      "exemptFeeMsat: ${state.exemptFeeMsat} "
      "channelFeeLimitMsat: ${state.channelFeeLimitMsat} "
      "saveEnabled: ${state.saveEnabled}",
    );
    await _preferences.setPaymentOptionsProportionalFee(state.proportionalFee);
    await _preferences.setPaymentOptionsExemptFee(state.exemptFeeMsat);
    await _preferences.setPaymentOptionsChannelSetupFeeLimit(state.channelFeeLimitMsat);
    emit(state.copyWith(saveEnabled: false));
  }

  Future<void> cancelEditing() async {
    _log.info("Canceling editing");
    if (state.saveEnabled) {
      await _fetchPaymentsOverrideSettings();
    }
  }

  Future<void> _fetchPaymentsOverrideSettings() async {
    _log.info("Fetching payments override settings");
    final proportionalFee = await _preferences.getPaymentOptionsProportionalFee();
    final exemptFeeMsat = await _preferences.getPaymentOptionsExemptFee();
    final channelFeeLimitMsat = await _preferences.getPaymentOptionsChannelSetupFeeLimitMsat();
    _log.info(
      "Payments override fetched: proportionalFee: $proportionalFee "
      "exemptFeeMsat: $exemptFeeMsat "
      "channelFeeLimitMsat: $channelFeeLimitMsat",
    );
    emit(
      PaymentOptionsState(
        proportionalFee: proportionalFee,
        exemptFeeMsat: exemptFeeMsat,
        channelFeeLimitMsat: channelFeeLimitMsat,
        saveEnabled: false,
      ),
    );
  }
}

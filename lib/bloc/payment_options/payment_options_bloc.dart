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

  Future<void> setAutoChannelSetupFeeLimitMsat(int autoChannelSetupFeeLimitMsat) async {
    emit(state.copyWith(autoChannelSetupFeeLimitMsat: autoChannelSetupFeeLimitMsat, saveEnabled: true));
  }

  Future<void> resetFees() async {
    _log.info("Resetting payments override settings to default: enabled: $kDefaultOverrideFee, "
        "proportional: $kDefaultProportionalFee");
    await _preferences.setPaymentOptionsProportionalFee(kDefaultProportionalFee);
    await _preferences.setPaymentOptionsExemptFee(kDefaultExemptFeeMsat);
    await _preferences.setPaymentOptionsAutoChannelSetupFeeLimit(kDefaultAutoChannelSetupFeeLimitMsat);
    emit(const PaymentOptionsState.initial());
  }

  Future<void> saveFees() async {
    final state = this.state;
    _log.info(
      "Saving payments override settings: proportionalFee: ${state.proportionalFee} "
      "exemptFeeMsat: ${state.exemptFeeMsat} "
      "autoChannelSetupFeeLimitMsat: ${state.autoChannelSetupFeeLimitMsat} "
      "saveEnabled: ${state.saveEnabled}",
    );
    await _preferences.setPaymentOptionsProportionalFee(state.proportionalFee);
    await _preferences.setPaymentOptionsExemptFee(state.exemptFeeMsat);
    await _preferences.setPaymentOptionsAutoChannelSetupFeeLimit(state.autoChannelSetupFeeLimitMsat);
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
    final autoChannelSetupFeeLimitMsat = await _preferences.getPaymentOptionsAutoChannelSetupFeeLimitMsat();
    _log.info(
      "Payments override fetched: proportionalFee: $proportionalFee "
      "exemptFeeMsat: $exemptFeeMsat "
      "autoChannelSetupFeeLimitMsat: $autoChannelSetupFeeLimitMsat",
    );
    emit(
      PaymentOptionsState(
        proportionalFee: proportionalFee,
        exemptFeeMsat: exemptFeeMsat,
        autoChannelSetupFeeLimitMsat: autoChannelSetupFeeLimitMsat,
        saveEnabled: false,
      ),
    );
  }
}

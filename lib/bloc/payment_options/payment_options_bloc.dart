import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:logging/logging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = Logger("PaymentOptionsBloc");

class PaymentOptionsBloc extends Cubit<PaymentOptionsState> {
  final Preferences _preferences;

  PaymentOptionsBloc(
    this._preferences,
  ) : super(const PaymentOptionsState.initial()) {
    _fetchPaymentsOverrideSettings().then((_) => _log.info("Initial settings read"));
  }

  Future<void> setOverrideFeeEnabled(bool enabled) async {
    emit(state.copyWith(
      overrideFeeEnabled: enabled,
      saveEnabled: true,
    ));
  }

  Future<void> setProportionalFee(double proportionalFee) async {
    emit(state.copyWith(
      proportionalFee: proportionalFee,
      saveEnabled: true,
    ));
  }

  Future<void> setExemptfeeMsat(int exemptfeeMsat) async {
    emit(state.copyWith(
      exemptFeeMsat: exemptfeeMsat,
      saveEnabled: true,
    ));
  }

  Future<void> resetFees() async {
    _log.info("Resetting payments override settings to default: enabled: $kDefaultOverrideFee, "
        "proportional: $kDefaultProportionalFee");
    await _preferences.setPaymentOptionsOverrideFeeEnabled(kDefaultOverrideFee);
    await _preferences.setPaymentOptionsProportionalFee(kDefaultProportionalFee);
    await _preferences.setPaymentOptionsExemptFee(kDefaultExemptFeeMsat);
    emit(const PaymentOptionsState.initial());
  }

  Future<void> saveFees() async {
    final state = this.state;
    _log.info("Saving payments override settings: enabled: ${state.overrideFeeEnabled}, "
        "proportional: ${state.proportionalFee}"
        "Exemptfee: ${state.exemptFeeMsat}");
    await _preferences.setPaymentOptionsOverrideFeeEnabled(state.overrideFeeEnabled);
    await _preferences.setPaymentOptionsProportionalFee(state.proportionalFee);
    await _preferences.setPaymentOptionsExemptFee(state.exemptFeeMsat);
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
    final enabled = await _preferences.getPaymentOptionsOverrideFeeEnabled();
    final proportional = await _preferences.getPaymentOptionsProportionalFee();
    final exemptFeeMsat = await _preferences.getPaymentOptionsExemptFee();
    _log.info(
        "Payments override fetched: enabled: $enabled, proportional: $proportional, exemptFeeMsat: $exemptFeeMsat");
    emit(PaymentOptionsState(
      overrideFeeEnabled: enabled,
      proportionalFee: proportional,
      exemptFeeMsat: exemptFeeMsat,
      saveEnabled: false,
    ));
  }
}

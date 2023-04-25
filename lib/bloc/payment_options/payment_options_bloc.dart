import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:fimber/fimber.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

final _log = FimberLog("PaymentOptionsBloc");

class PaymentOptionsBloc extends Cubit<PaymentOptionsState> {
  final Preferences _preferences;

  PaymentOptionsBloc(
    this._preferences,
  ) : super(const PaymentOptionsState.initial()) {
    _fetchPaymentsOverrideSettings().then((_) => _log.v("Initial settings read"));
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

  Future<void> resetFees() async {
    _log.v("Resetting payments override settings to default: enabled: $kDefaultOverrideFee, "
        "proportional: $kDefaultProportionalFee");
    await _preferences.setPaymentOptionsOverrideFeeEnabled(kDefaultOverrideFee);
    await _preferences.setPaymentOptionsProportionalFee(kDefaultProportionalFee);
    emit(const PaymentOptionsState.initial());
  }

  Future<void> saveFees() async {
    final state = this.state;
    _log.v("Saving payments override settings: enabled: ${state.overrideFeeEnabled}, "
        "proportional: ${state.proportionalFee}");
    await _preferences.setPaymentOptionsOverrideFeeEnabled(state.overrideFeeEnabled);
    await _preferences.setPaymentOptionsProportionalFee(state.proportionalFee);
    emit(state.copyWith(saveEnabled: false));
  }

  Future<void> cancelEditing() async {
    _log.v("Canceling editing");
    if (state.saveEnabled) {
      await _fetchPaymentsOverrideSettings();
    }
  }

  Future<void> _fetchPaymentsOverrideSettings() async {
    _log.v("Fetching payments override settings");
    final enabled = await _preferences.getPaymentOptionsOverrideFeeEnabled();
    final proportional = await _preferences.getPaymentOptionsProportionalFee();
    _log.v("Payments override fetched: enabled: $enabled, proportional: $proportional");
    emit(PaymentOptionsState(
      overrideFeeEnabled: enabled,
      proportionalFee: proportional,
      saveEnabled: false,
    ));
  }
}

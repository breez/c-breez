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
    resetPaymentOptions(true);
  }

  Future<void> setProportionalFee(double proportionalFee) async {
    await _preferences.setPaymentOptionsProportionalFee(state.proportionalFee);
    emit(state.copyWith(proportionalFee: proportionalFee));
  }

  Future<void> setExemptfeeMsat(int exemptFeeMsat) async {
    await _preferences.setPaymentOptionsExemptFee(state.exemptFeeMsat);
    emit(state.copyWith(exemptFeeMsat: exemptFeeMsat));
  }

  Future<void> setChannelSetupFeeLimitMsat(int channelFeeLimitMsat) async {
    await _preferences.setPaymentOptionsChannelSetupFeeLimit(state.channelFeeLimitMsat);
    emit(state.copyWith(channelFeeLimitMsat: channelFeeLimitMsat));
  }

  Future<void> resetPaymentOptions([bool checkPaymentOptions = false]) async {
    final hasPaymentOptions = await _preferences.hasPaymentOptions();
    if (!checkPaymentOptions || !hasPaymentOptions) {
      try {
        await _preferences.setPaymentOptionsProportionalFee(kDefaultProportionalFee);
        await _preferences.setPaymentOptionsExemptFee(kDefaultExemptFeeMsat);
        await _preferences.setPaymentOptionsChannelSetupFeeLimit(kDefaultChannelSetupFeeLimitMsat);
        _log.info(
          "Reverted payment options to default values: "
          "proportionalFee: $kDefaultProportionalFee "
          "exemptFeeMsat: $kDefaultExemptFeeMsat "
          "channelFeeLimitMsat: $kDefaultChannelSetupFeeLimitMsat",
        );
      } catch (e) {
        _log.severe("Failed to reset payment options.");
        rethrow;
      }
    }

    await getPaymentOptions();
  }

  Future<void> getPaymentOptions() async {
    final proportionalFee = await _preferences.getPaymentOptionsProportionalFee();
    final exemptFeeMsat = await _preferences.getPaymentOptionsExemptFee();
    final channelFeeLimitMsat = await _preferences.getPaymentOptionsChannelSetupFeeLimitMsat();
    emit(
      state.copyWith(
        proportionalFee: proportionalFee,
        exemptFeeMsat: exemptFeeMsat,
        channelFeeLimitMsat: channelFeeLimitMsat,
      ),
    );
    _log.info(
      "Read payment options: proportionalFee: $proportionalFee "
      "exemptFeeMsat: $exemptFeeMsat "
      "channelFeeLimitMsat: $channelFeeLimitMsat",
    );
  }
}

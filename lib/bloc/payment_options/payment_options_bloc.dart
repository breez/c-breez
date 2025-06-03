import 'package:c_breez/bloc/payment_options/payment_options_state.dart';
import 'package:c_breez/utils/preferences.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';

final _log = Logger("PaymentOptionsBloc");

class PaymentOptionsBloc extends Cubit<PaymentOptionsState> {
  final Preferences _preferences;

  PaymentOptionsBloc(this._preferences) : super(const PaymentOptionsState.initial()) {
    _initializePaymentOptions();
  }

  void _initializePaymentOptions() async {
    await _preferences.hasPaymentOptions() ? await _getPaymentOptions() : await setDefaultPaymentOptions();
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

  Future<void> setDefaultPaymentOptions() async {
    try {
      await _preferences.setPaymentOptionsProportionalFee(kDefaultProportionalFee);
      await _preferences.setPaymentOptionsExemptFee(kDefaultExemptFeeMsat);
      await _preferences.setPaymentOptionsChannelSetupFeeLimit(kDefaultChannelSetupFeeLimitMsat);
      emit(const PaymentOptionsState.initial());
      _log.info(
        "Set payment options to default values: "
        "proportionalFee: $kDefaultProportionalFee "
        "exemptFeeMsat: $kDefaultExemptFeeMsat "
        "channelFeeLimitMsat: $kDefaultChannelSetupFeeLimitMsat",
      );
    } catch (e) {
      _log.severe("Failed to set default payment options.");
      rethrow;
    }
  }

  Future<void> _getPaymentOptions() async {
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

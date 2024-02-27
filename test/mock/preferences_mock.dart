import 'package:c_breez/utils/preferences.dart';
import 'package:mockito/mockito.dart';

class PreferencesMock extends Mock implements Preferences {
  String? mempoolSpaceUrl = "https://mempool.space/";

  @override
  Future<String?> getMempoolSpaceUrl() => Future<String?>.value(mempoolSpaceUrl);

  String? setMempoolSpaceUrlUrl;

  @override
  Future<void> setMempoolSpaceUrl(String url) {
    setMempoolSpaceUrlUrl = url;
    return Future<void>.value();
  }

  int resetMempoolSpaceUrlCalled = 0;

  @override
  Future<void> resetMempoolSpaceUrl() {
    resetMempoolSpaceUrlCalled++;
    return Future<void>.value();
  }

  double paymentOptionsProportionalFee = kDefaultProportionalFee;

  @override
  Future<double> getPaymentOptionsProportionalFee() => Future<double>.value(paymentOptionsProportionalFee);

  int setPaymentOptionsProportionalFeeCalled = 0;

  @override
  Future<void> setPaymentOptionsProportionalFee(double fee) {
    setPaymentOptionsProportionalFeeCalled++;
    return Future<void>.value();
  }

  int setPaymentOptionsExemptFeeCalled = 0;

  @override
  Future<void> setPaymentOptionsExemptFee(int exemptFee) {
    setPaymentOptionsExemptFeeCalled++;
    return Future<void>.value();
  }

  int paymentOptionsExemptfee = kDefaultExemptFeeMsat;

  @override
  Future<int> getPaymentOptionsExemptFee() => Future<int>.value(paymentOptionsExemptfee);

  int setPaymentOptionsChannelSetupFeeLimitCalled = 0;

  @override
  Future<void> setPaymentOptionsChannelSetupFeeLimit(int channelFeeLimitMsat) {
    setPaymentOptionsChannelSetupFeeLimitCalled++;
    return Future<void>.value();
  }

  int paymentOptionsChannelSetupFeeLimit = kDefaultChannelSetupFeeLimitMsat;

  @override
  Future<int> getPaymentOptionsChannelSetupFeeLimitMsat() =>
      Future<int>.value(paymentOptionsChannelSetupFeeLimit);
}

import 'package:c_breez/models/bug_report_behavior.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kDefaultOverrideFee = false;
const kDefaultProportionalFee = 1.0;
const kDefaultExemptFeeMsat = 20000;
const kDefaultAutoChannelSetupFeeLimitMsat = 5000000;

const _mempoolSpaceUrlKey = "mempool_space_url";
const _kPaymentOptionProportionalFee = "payment_options_proportional_fee";
const _kPaymentOptionExemptFee = "payment_options_exempt_fee";
const _kPaymentOptionAutoChannelSetupFeeLimit = "payment_options_auto_channel_setup_fee_limit";
const _kReportPrefKey = "report_preference_key";

final _log = Logger("Preferences");

class Preferences {
  const Preferences();

  Future<String?> getMempoolSpaceUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mempoolSpaceUrlKey);
  }

  Future<void> setMempoolSpaceUrl(String url) async {
    _log.info("set mempool space url: $url");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mempoolSpaceUrlKey, url);
  }

  Future<void> resetMempoolSpaceUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mempoolSpaceUrlKey);
  }

  Future<double> getPaymentOptionsProportionalFee() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kPaymentOptionProportionalFee) ?? kDefaultProportionalFee;
  }

  Future<void> setPaymentOptionsProportionalFee(double fee) async {
    _log.info("set payment options proportional fee: $fee");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kPaymentOptionProportionalFee, fee);
  }

  Future<int> getPaymentOptionsExemptFee() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kPaymentOptionExemptFee) ?? kDefaultExemptFeeMsat;
  }

  Future<void> setPaymentOptionsExemptFee(int exemptfeeMsat) async {
    _log.info("set payment options exempt fee : $exemptfeeMsat");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kPaymentOptionExemptFee, exemptfeeMsat);
  }

  Future<int> getPaymentOptionsAutoChannelSetupFeeLimitMsat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kPaymentOptionAutoChannelSetupFeeLimit) ?? kDefaultAutoChannelSetupFeeLimitMsat;
  }

  Future<void> setPaymentOptionsAutoChannelSetupFeeLimit(int autoChannelSetupFeeLimitMsat) async {
    _log.info("set payment options channel creation limit fee : $autoChannelSetupFeeLimitMsat");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kPaymentOptionAutoChannelSetupFeeLimit, autoChannelSetupFeeLimitMsat);
  }

  Future<BugReportBehavior> getBugReportBehavior() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_kReportPrefKey);
    if (value == null || value < 0 || value >= BugReportBehavior.values.length) {
      return BugReportBehavior.PROMPT;
    }
    return BugReportBehavior.values[value];
  }

  Future<void> setBugReportBehavior(BugReportBehavior behavior) async {
    _log.info("set bug report behavior: $behavior");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kReportPrefKey, behavior.index);
  }
}

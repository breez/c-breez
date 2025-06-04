import 'package:breez_sdk/sdk.dart';
import 'package:breez_translations/generated/breez_translations.dart';

enum ProcessingSpeed {
  economy(Duration(minutes: 60)),
  regular(Duration(minutes: 30)),
  priority(Duration(minutes: 10));

  const ProcessingSpeed(this.waitingTime);
  final Duration waitingTime;
}

abstract class FeeOption {
  final int txFeeSat;
  final ProcessingSpeed processingSpeed;
  final int satPerVbyte;

  FeeOption({required this.txFeeSat, required this.processingSpeed, required this.satPerVbyte});

  String getDisplayName(BreezTranslations texts) {
    switch (processingSpeed) {
      case ProcessingSpeed.economy:
        return texts.fee_chooser_option_economy;
      case ProcessingSpeed.regular:
        return texts.fee_chooser_option_regular;
      case ProcessingSpeed.priority:
        return texts.fee_chooser_option_priority;
    }
  }

  bool isAffordable({int? balanceSat, int? walletBalanceSat, required int amountSat});
}

class ReverseSwapFeeOption extends FeeOption {
  final PrepareOnchainPaymentResponse pairInfo;

  ReverseSwapFeeOption({
    required this.pairInfo,
    required super.txFeeSat,
    required super.processingSpeed,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({int? balanceSat, int? walletBalanceSat, required int amountSat}) {
    assert(balanceSat != null);

    return balanceSat! >= pairInfo.senderAmountSat.toInt();
  }
}

class RefundFeeOption extends FeeOption {
  RefundFeeOption({required super.txFeeSat, required super.processingSpeed, required super.satPerVbyte});

  @override
  bool isAffordable({int? balanceSat, int? walletBalanceSat, required int amountSat}) {
    return (amountSat >= txFeeSat);
  }
}

class RedeemOnchainFeeOption extends FeeOption {
  RedeemOnchainFeeOption({
    required super.txFeeSat,
    required super.processingSpeed,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({int? balanceSat, int? walletBalanceSat, required int amountSat}) {
    assert(walletBalanceSat != null);

    return (walletBalanceSat! >= amountSat);
  }
}

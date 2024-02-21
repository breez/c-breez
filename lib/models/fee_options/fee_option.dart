import 'package:breez_sdk/bridge_generated.dart';
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

  FeeOption({
    required this.txFeeSat,
    required this.processingSpeed,
    required this.satPerVbyte,
  });

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

  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue});
}

class ReverseSwapFeeOption extends FeeOption {
  final ReverseSwapPairInfo pairInfo;

  ReverseSwapFeeOption({
    required this.pairInfo,
    required super.txFeeSat,
    required super.processingSpeed,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue}) {
    if (isMaxValue == true) {
      return (amountSat + boltzServiceFee(amountSat) + pairInfo.feesClaim) > 0;
    } else {
      return (amountSat + boltzServiceFee(amountSat) + pairInfo.feesClaim) < balance;
    }
  }

  int boltzServiceFee(int amountSat) {
    var p = pairInfo.feesPercentage / 100;
    // swap amount + claim tx fee
    var totalAmount = (amountSat + pairInfo.feesClaim).toDouble();
    var percentageFee = totalAmount * p / (1 - p);
    var minerFee = pairInfo.feesLockup.toDouble() / (1 - p);
    return (percentageFee + minerFee).ceil();
  }
}

class RefundFeeOption extends FeeOption {
  RefundFeeOption({
    required super.txFeeSat,
    required super.processingSpeed,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue}) {
    return (amountSat + txFeeSat) < balance;
  }
}

class RedeemOnchainFeeOption extends FeeOption {
  RedeemOnchainFeeOption({
    required super.txFeeSat,
    required super.processingSpeed,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue}) {
    return (amountSat + txFeeSat) < balance;
  }
}

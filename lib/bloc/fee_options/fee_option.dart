import 'package:breez_sdk/bridge_generated.dart';
import 'package:breez_translations/generated/breez_translations.dart';

enum ProcessingSpeed {
  economy,
  regular,
  priority,
}

abstract class FeeOption {
  final ProcessingSpeed processingSpeed;
  final Duration waitingTime;
  final int satPerVbyte;

  FeeOption({
    required this.processingSpeed,
    required this.waitingTime,
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
    required super.processingSpeed,
    required super.waitingTime,
    required super.satPerVbyte,
  });

  int get txFeeSat => pairInfo.feesClaim;

  @override
  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue}) {
    if (isMaxValue == true) {
      return (amountSat + pairInfo.totalEstimatedFees!) > 0;
    } else {
      return (amountSat + pairInfo.totalEstimatedFees!) < balance;
    }
  }
}

class RefundFeeOption extends FeeOption {
  final int txFeeSat;

  RefundFeeOption({
    required this.txFeeSat,
    required super.processingSpeed,
    required super.waitingTime,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue}) {
    return (amountSat + txFeeSat) < balance;
  }
}

class RedeemOnchainFeeOption extends FeeOption {
  final int txFeeSat;

  RedeemOnchainFeeOption({
    required this.txFeeSat,
    required super.processingSpeed,
    required super.waitingTime,
    required super.satPerVbyte,
  });

  @override
  bool isAffordable({required int balance, required int amountSat, bool? isMaxValue}) {
    return (amountSat + txFeeSat) < balance;
  }
}

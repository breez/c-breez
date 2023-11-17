import 'package:breez_translations/generated/breez_translations.dart';

enum ProcessingSpeed {
  economy,
  regular,
  priority,
}

class FeeOption {
  final ProcessingSpeed processingSpeed;
  final Duration waitingTime;
  final int fee;
  final int feeVByte;

  FeeOption({
    required this.processingSpeed,
    required this.waitingTime,
    required this.fee,
    required this.feeVByte,
  });

  bool isAffordable(int walletBalance) => (walletBalance - fee) > 0;

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
}

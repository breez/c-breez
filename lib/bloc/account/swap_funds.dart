class SwapFundsStatus {
  const SwapFundsStatus();

  factory SwapFundsStatus.initial() => const SwapFundsStatus();

  Map<String, dynamic>? toJson() {
    return {};
  }

  factory SwapFundsStatus.fromJson(Map<String, dynamic> json) {
    return const SwapFundsStatus();
  }

  List<RefundableAddress> get waitingRefundAddresses {
    return [
      const RefundableAddress(
        "An address", // TODO uses real data
      ),
    ];
  }
}

class RefundableAddress {
  final String address;

  const RefundableAddress(
    this.address,
  );
}

import 'package:c_breez/bloc/account/payments_state.dart';
import 'package:c_breez/bloc/account/swap_funds.dart';
import 'package:fixnum/fixnum.dart';

const initialInboundCapacity = 4000000;

enum AccountStatus { CONNECTING, CONNECTED, DISCONNECTION, DISCONNECTED }

class AccountState {
  final String? id;
  final bool initial;
  final Int64 blockheight;
  final Int64 balance;
  final Int64 walletBalance;
  final AccountStatus status;
  final Int64 maxAllowedToPay;
  final Int64 maxAllowedToReceive;
  final Int64 maxPaymentAmount;
  final Int64 maxChanReserve;
  final List<String> connectedPeers;
  final Int64 maxInboundLiquidity;
  final Int64 onChainFeeRate;
  final PaymentsState payments;
  final SwapFundsStatus swapFundsStatus;

  const AccountState({
    required this.payments,
    required this.id,
    required this.initial,
    required this.blockheight,
    required this.balance,
    required this.walletBalance,
    required this.status,
    required this.maxAllowedToPay,
    required this.maxAllowedToReceive,
    required this.maxPaymentAmount,
    required this.maxChanReserve,
    required this.connectedPeers,
    required this.maxInboundLiquidity,
    required this.onChainFeeRate,
    required this.swapFundsStatus,
  });

  AccountState.initial()
      : this(
          id: null,
          blockheight: Int64(0),
          status: AccountStatus.DISCONNECTED,
          maxAllowedToPay: Int64(0),
          maxAllowedToReceive: Int64(0),
          maxPaymentAmount: Int64(0),
          maxChanReserve: Int64(0),
          connectedPeers: List.empty(),
          maxInboundLiquidity: Int64(0),
          onChainFeeRate: Int64(0),
          balance: Int64(0),
          walletBalance: Int64(0),
          payments: PaymentsState.initial(),
          initial: true,
          swapFundsStatus: SwapFundsStatus.initial(),
        );

  AccountState copyWith({
    String? id,
    PaymentsState? payments,
    bool? initial,
    Int64? blockheight,
    Int64? balance,
    Int64? walletBalance,
    AccountStatus? status,
    Int64? maxAllowedToPay,
    Int64? maxAllowedToReceive,
    Int64? maxPaymentAmount,
    Int64? maxChanReserve,
    List<String>? connectedPeers,
    Int64? maxInboundLiquidity,
    Int64? onChainFeeRate,
    SwapFundsStatus? swapFundsStatus,
  }) {
    return AccountState(
      payments: payments ?? this.payments,
      id: id ?? this.id,
      initial: initial ?? this.initial,
      balance: balance ?? this.balance,
      walletBalance: walletBalance ?? this.walletBalance,
      status: status ?? this.status,
      maxAllowedToPay: maxAllowedToPay ?? this.maxAllowedToPay,
      maxAllowedToReceive: maxAllowedToReceive ?? this.maxAllowedToReceive,
      maxPaymentAmount: maxPaymentAmount ?? this.maxPaymentAmount,
      blockheight: blockheight ?? this.blockheight,
      maxChanReserve: maxChanReserve ?? this.maxChanReserve,
      connectedPeers: connectedPeers ?? this.connectedPeers,
      maxInboundLiquidity: maxInboundLiquidity ?? this.maxInboundLiquidity,
      onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate,
      swapFundsStatus: swapFundsStatus ?? this.swapFundsStatus,
    );
  }

  Int64 get reserveAmount => balance - maxAllowedToPay;

  Map<String, dynamic>? toJson() {
    return {
      "id": id,
      "initial": initial,
      "blockheight": blockheight.toInt(),
      "balance": balance.toInt(),
      "walletBalance": walletBalance.toInt(),
      "status": status.index,
      "maxAllowedToPay": maxAllowedToPay.toInt(),
      "maxAllowedToReceive": maxAllowedToReceive.toInt(),
      "maxPaymentAmount": maxPaymentAmount.toInt(),
      "maxChanReserve": maxChanReserve.toInt(),
      "maxInboundLiquidity": maxInboundLiquidity.toInt(),
      "onChainFeeRate": onChainFeeRate.toInt(),
      "swapFundsStatus": swapFundsStatus.toJson(),
    };
  }

  factory AccountState.fromJson(Map<String, dynamic> json) {
    return AccountState(
      payments: PaymentsState.initial(),
      id: json["id"],
      initial: json["initial"],
      blockheight: Int64(json["blockheight"]),
      balance: Int64(json["balance"]),
      walletBalance: Int64(json["walletBalance"]),
      status: json["status"] != null
          ? AccountStatus.values[json["status"]]
          : AccountStatus.DISCONNECTED,
      maxAllowedToPay: Int64(json["maxAllowedToPay"]),
      maxAllowedToReceive: Int64(json["maxAllowedToReceive"]),
      maxPaymentAmount: Int64(json["maxPaymentAmount"]),
      maxChanReserve: Int64(json["maxChanReserve"]),
      connectedPeers: <String>[],
      maxInboundLiquidity: Int64(json["maxInboundLiquidity"] ?? 0),
      onChainFeeRate: Int64(json["onChainFeeRate"]),
      swapFundsStatus: SwapFundsStatus.fromJson(json["swapFundsStatus"]),
    );
  }
}

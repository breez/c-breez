import 'package:breez_sdk/bridge_generated.dart';

const initialInboundCapacity = 4000000;

enum AccountStatus { CONNECTING, CONNECTED, DISCONNECTION, DISCONNECTED }

class AccountState {
  final String? id;
  final bool initial;
  final int blockheight;
  final int balance;
  final int walletBalance;
  final AccountStatus status;
  final int maxAllowedToPay;
  final int maxAllowedToReceive;
  final int maxPaymentAmount;
  final int maxChanReserve;
  final List<String> connectedPeers;
  final int maxInboundLiquidity;
  final int onChainFeeRate;
  final List<LightningTransaction> transactions;

  const AccountState({
    required this.transactions,
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
  });

  AccountState.initial()
      : this(
          id: null,
          blockheight: 0,
          status: AccountStatus.DISCONNECTED,
          maxAllowedToPay: 0,
          maxAllowedToReceive: 0,
          maxPaymentAmount: 0,
          maxChanReserve: 0,
          connectedPeers: List.empty(),
          maxInboundLiquidity: 0,
          onChainFeeRate: 0,
          balance: 0,
          walletBalance: 0,
          transactions: [],
          initial: true,
        );

  AccountState copyWith({
    String? id,
    List<LightningTransaction>? transactions,
    bool? initial,
    int? blockheight,
    int? balance,
    int? walletBalance,
    AccountStatus? status,
    int? maxAllowedToPay,
    int? maxAllowedToReceive,
    int? maxPaymentAmount,
    int? maxChanReserve,
    List<String>? connectedPeers,
    int? maxInboundLiquidity,
    int? onChainFeeRate,
  }) {
    return AccountState(
        transactions: transactions ?? this.transactions,
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
        onChainFeeRate: onChainFeeRate ?? this.onChainFeeRate);
  }

  int get reserveAmount => balance - maxAllowedToPay;

  Map<String, dynamic>? toJson() {
    return {
      "id": id,
      "initial": initial,
      "blockheight": blockheight,
      "balance": balance,
      "walletBalance": walletBalance,
      "status": status.index,
      "maxAllowedToPay": maxAllowedToPay,
      "maxAllowedToReceive": maxAllowedToReceive,
      "maxPaymentAmount": maxPaymentAmount,
      "maxChanReserve": maxChanReserve,
      "maxInboundLiquidity": maxInboundLiquidity,
      "onChainFeeRate": onChainFeeRate,
    };
  }

  factory AccountState.fromJson(Map<String, dynamic> json) {
    return AccountState(
        transactions: [],
        id: json["id"],
        initial: json["initial"],
        blockheight: json["blockheight"],
        balance: json["balance"],
        walletBalance: json["walletBalance"],
        status: json["status"] != null
            ? AccountStatus.values[json["status"]]
            : AccountStatus.DISCONNECTED,
        maxAllowedToPay: json["maxAllowedToPay"],
        maxAllowedToReceive: json["maxAllowedToReceive"],
        maxPaymentAmount: json["maxPaymentAmount"],
        maxChanReserve: json["maxChanReserve"],
        connectedPeers: <String>[],
        maxInboundLiquidity: json["maxInboundLiquidity"] ?? 0,
        onChainFeeRate: (json["onChainFeeRate"]));
  }
}

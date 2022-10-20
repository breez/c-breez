import 'package:breez_sdk/src/chain_service/payload/recommended_fee_payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chain_service.g.dart';

abstract class ChainService {
  Future<List<OnchainTransaction>> fetchTransactionsForAddress(String address);

  Future<UTXOStatus> fetchUtxoStatus(String txid);

  Future<RecommendedFeePayload> fetchRecommendedFees();
}

@JsonSerializable(explicitToJson: true)
class OnchainTransaction {
  final bool confirmed;
  final int? blockHeight;
  final List<VIn> inputs;
  final List<VOut> outputs;

  OnchainTransaction(this.confirmed, this.blockHeight, this.inputs, this.outputs);

  factory OnchainTransaction.fromJson(Map<String, dynamic> json) => _$OnchainTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$OnchainTransactionToJson(this);
}

@JsonSerializable()
class VOut {
  final String scriptpubkey;
  final String scriptpubkeyType;
  final String scriptpubkeyAddress;
  final int value;

  VOut(this.scriptpubkey, this.scriptpubkeyType, this.scriptpubkeyAddress, this.value);

  factory VOut.fromJson(Map<String, dynamic> json) => _$VOutFromJson(json);
  Map<String, dynamic> toJson() => _$VOutToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VIn {
  final String txID;
  final int vout;
  final VOut prevOut;

  VIn(this.txID, this.vout, this.prevOut);

  factory VIn.fromJson(Map<String, dynamic> json) => _$VInFromJson(json);
  Map<String, dynamic> toJson() => _$VInToJson(this);
}

@JsonSerializable()
class UTXOStatus {
  final bool spent;
  final String txid;
  final bool confirmed;
  final int? blockHeight;

  UTXOStatus(this.spent, this.txid, this.confirmed, this.blockHeight);

  factory UTXOStatus.fromJson(Map<String, dynamic> json) => _$UTXOStatusFromJson(json);
  Map<String, dynamic> toJson() => _$UTXOStatusToJson(this);
}

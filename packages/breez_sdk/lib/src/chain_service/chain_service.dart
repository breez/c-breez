import 'package:freezed_annotation/freezed_annotation.dart';

import 'mempool_space.dart';

part 'chain_service.g.dart';

abstract class ChainService {
  static final defaulService = MempoolSpace("mempool.space");

  Future<List<OnchainTransaction>> fetchTransactionsForAddress(String address);

  Future<UTXOStatus> fetchUtxoStatus(String txid);
}

@JsonSerializable(explicitToJson: true)
class OnchainTransaction {
  final bool confirmed;
  final int blockHeight;
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
  final int blockHeight;

  UTXOStatus(this.spent, this.txid, this.confirmed, this.blockHeight);

  factory UTXOStatus.fromJson(Map<String, dynamic> json) => _$UTXOStatusFromJson(json);
  Map<String, dynamic> toJson() => _$UTXOStatusToJson(this);
}

void main() async {
  final txs = await ChainService.defaulService.fetchTransactionsForAddress("bc1qgd7f60mfjn24vuv6uvatlez2tuu4a6zkyf86lev77eh8vdu6xlhs7nz6wh");
  print(txs[0].toJson());
  final status =
      await ChainService.defaulService.fetchUtxoStatus("07c9d3fbffc20f96ea7c93ef3bcdf346c8a8456c25850ea76be62b24a7cf690c");
  print(status.toJson());
}

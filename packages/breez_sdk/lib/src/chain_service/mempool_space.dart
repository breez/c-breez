import 'dart:convert';

import 'package:breez_sdk/src/chain_service/chain_service.dart';
import 'package:breez_sdk/src/chain_service/payload/recommended_fee_payload.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
part 'mempool_space.g.dart';

class MempoolSpace extends ChainService {
  final String domain;

  MempoolSpace(this.domain);

  Uri _getUrl(String relative) {
    return Uri.parse('https://$domain/api/$relative');
  } 

  @override
  Future<List<OnchainTransaction>> fetchTransactionsForAddress(String address) async {
    var url = _getUrl('address/$address/txs');
    final response = await http.read(url);
    final List txs = json.decode(response);
    final transactions = txs.map<OnchainTransaction>((e) {      
      return MSpaceOnchainTransaction.fromJson(e);
    });
    return transactions.toList();
  }

  @override
  Future<UTXOStatus> fetchUtxoStatus(String txid) async {
    var url = _getUrl('tx/$txid/outspend/0');
    final response = await http.read(url);
    final Map<String, dynamic> firstOutput = json.decode(response);
    return MSpaceUTXOStatus.fromJson(firstOutput);
  }

  @override
  Future<RecommendedFeePayload> fetchRecommendedFees() async {
    final response = await http.read(_getUrl('v1/fees/recommended'));
    return RecommendedFeePayload.fromJson(json.decode(response));
  }
}

@JsonSerializable(explicitToJson: true)
class MSpaceUTXOStatus implements UTXOStatus {
  @override
  final bool spent;

  @override
  final String txid;
  final MSpaceTxStatus status;

  MSpaceUTXOStatus(this.spent, this.txid, this.status);

  factory MSpaceUTXOStatus.fromJson(Map<String, dynamic> json) => _$MSpaceUTXOStatusFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MSpaceUTXOStatusToJson(this);
  
  @override
  int? get blockHeight => status.blockHeight;
  
  @override  
  bool get confirmed => status.confirmed;
}

@JsonSerializable()
class MSpaceTxStatus {  

  @JsonKey(required: true, name: "confirmed")  
  final bool confirmed;

  @JsonKey(name: "block_height")
  final int? blockHeight;
  
  MSpaceTxStatus(this.confirmed, this.blockHeight);

  factory MSpaceTxStatus.fromJson(Map<String, dynamic> json) => _$MSpaceTxStatusFromJson(json);
  Map<String, dynamic> toJson() => _$MSpaceTxStatusToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MSpaceOnchainTransaction implements OnchainTransaction{

  @JsonKey(required: true, name: "txid")
  final String txId;

  @JsonKey(required: true, name: "status")
  final MSpaceTxStatus status;
  
  @JsonKey(required: true, name: "vin")
  final List<MSpaceVIn> mspaceInputs;

  @JsonKey(required: true, name: "vout")
  final List<MSpaceVOut> mspaceOutputs;  

  MSpaceOnchainTransaction(this.txId, this.status, this.mspaceInputs, this.mspaceOutputs);

  factory MSpaceOnchainTransaction.fromJson(Map<String, dynamic> json) => _$MSpaceOnchainTransactionFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MSpaceOnchainTransactionToJson(this);

  @override
  List<VOut> get outputs => mspaceOutputs.map((e) => e as VOut).toList();

  @override
  List<VIn> get inputs => mspaceInputs.map((e) => e as VIn).toList();

  @override  
  int? get blockHeight => status.blockHeight;

  @override  
  bool get confirmed => status.confirmed;
}

@JsonSerializable()
class MSpaceVOut implements VOut {
  final String scriptpubkey;

  @JsonKey(name: "scriptpubkey_type")
  final String scriptpubkeyType;

  @JsonKey(name: "scriptpubkey_address")
  final String scriptpubkeyAddress;
  final int value;

  MSpaceVOut(this.scriptpubkey, this.scriptpubkeyType, this.scriptpubkeyAddress, this.value);

  factory MSpaceVOut.fromJson(Map<String, dynamic> json) => _$MSpaceVOutFromJson(json);
  Map<String, dynamic> toJson() => _$MSpaceVOutToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MSpaceVIn implements VIn {
  @JsonKey(name: "txid")
  final String txID;
  
  final int vout;

  @JsonKey(name: "prevout")
  final MSpaceVOut prevOut;

  MSpaceVIn(this.txID, this.vout, this.prevOut);

  factory MSpaceVIn.fromJson(Map<String, dynamic> json) => _$MSpaceVInFromJson(json);
  Map<String, dynamic> toJson() => _$MSpaceVInToJson(this);
}

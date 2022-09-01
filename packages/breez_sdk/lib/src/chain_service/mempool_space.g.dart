// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mempool_space.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MSpaceUTXOStatus _$MSpaceUTXOStatusFromJson(Map<String, dynamic> json) =>
    MSpaceUTXOStatus(
      json['spent'] as bool,
      json['txid'] as String,
      MSpaceTxStatus.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MSpaceUTXOStatusToJson(MSpaceUTXOStatus instance) =>
    <String, dynamic>{
      'spent': instance.spent,
      'txid': instance.txid,
      'status': instance.status.toJson(),
    };

MSpaceTxStatus _$MSpaceTxStatusFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['confirmed', 'block_height'],
  );
  return MSpaceTxStatus(
    json['confirmed'] as bool,
    json['block_height'] as int,
  );
}

Map<String, dynamic> _$MSpaceTxStatusToJson(MSpaceTxStatus instance) =>
    <String, dynamic>{
      'confirmed': instance.confirmed,
      'block_height': instance.blockHeight,
    };

MSpaceOnchainTransaction _$MSpaceOnchainTransactionFromJson(
    Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['txid', 'status', 'vin', 'vout'],
  );
  return MSpaceOnchainTransaction(
    json['txid'] as String,
    MSpaceTxStatus.fromJson(json['status'] as Map<String, dynamic>),
    (json['vin'] as List<dynamic>)
        .map((e) => MSpaceVIn.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['vout'] as List<dynamic>)
        .map((e) => MSpaceVOut.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$MSpaceOnchainTransactionToJson(
        MSpaceOnchainTransaction instance) =>
    <String, dynamic>{
      'txid': instance.txId,
      'status': instance.status.toJson(),
      'vin': instance.mspaceInputs.map((e) => e.toJson()).toList(),
      'vout': instance.mspaceOutputs.map((e) => e.toJson()).toList(),
    };

MSpaceVOut _$MSpaceVOutFromJson(Map<String, dynamic> json) => MSpaceVOut(
      json['scriptpubkey'] as String,
      json['scriptpubkey_type'] as String,
      json['scriptpubkey_address'] as String,
      json['value'] as int,
    );

Map<String, dynamic> _$MSpaceVOutToJson(MSpaceVOut instance) =>
    <String, dynamic>{
      'scriptpubkey': instance.scriptpubkey,
      'scriptpubkey_type': instance.scriptpubkeyType,
      'scriptpubkey_address': instance.scriptpubkeyAddress,
      'value': instance.value,
    };

MSpaceVIn _$MSpaceVInFromJson(Map<String, dynamic> json) => MSpaceVIn(
      json['txid'] as String,
      json['vout'] as int,
      MSpaceVOut.fromJson(json['prevout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MSpaceVInToJson(MSpaceVIn instance) => <String, dynamic>{
      'txid': instance.txID,
      'vout': instance.vout,
      'prevout': instance.prevOut.toJson(),
    };

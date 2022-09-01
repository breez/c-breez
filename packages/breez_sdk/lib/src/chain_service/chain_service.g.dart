// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnchainTransaction _$OnchainTransactionFromJson(Map<String, dynamic> json) =>
    OnchainTransaction(
      json['confirmed'] as bool,
      json['blockHeight'] as int,
      (json['inputs'] as List<dynamic>)
          .map((e) => VIn.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['outputs'] as List<dynamic>)
          .map((e) => VOut.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OnchainTransactionToJson(OnchainTransaction instance) =>
    <String, dynamic>{
      'confirmed': instance.confirmed,
      'blockHeight': instance.blockHeight,
      'inputs': instance.inputs.map((e) => e.toJson()).toList(),
      'outputs': instance.outputs.map((e) => e.toJson()).toList(),
    };

VOut _$VOutFromJson(Map<String, dynamic> json) => VOut(
      json['scriptpubkey'] as String,
      json['scriptpubkeyType'] as String,
      json['scriptpubkeyAddress'] as String,
      json['value'] as int,
    );

Map<String, dynamic> _$VOutToJson(VOut instance) => <String, dynamic>{
      'scriptpubkey': instance.scriptpubkey,
      'scriptpubkeyType': instance.scriptpubkeyType,
      'scriptpubkeyAddress': instance.scriptpubkeyAddress,
      'value': instance.value,
    };

VIn _$VInFromJson(Map<String, dynamic> json) => VIn(
      json['txID'] as String,
      json['vout'] as int,
      VOut.fromJson(json['prevOut'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VInToJson(VIn instance) => <String, dynamic>{
      'txID': instance.txID,
      'vout': instance.vout,
      'prevOut': instance.prevOut.toJson(),
    };

UTXOStatus _$UTXOStatusFromJson(Map<String, dynamic> json) => UTXOStatus(
      json['spent'] as bool,
      json['txid'] as String,
      json['confirmed'] as bool,
      json['blockHeight'] as int,
    );

Map<String, dynamic> _$UTXOStatusToJson(UTXOStatus instance) =>
    <String, dynamic>{
      'spent': instance.spent,
      'txid': instance.txid,
      'confirmed': instance.confirmed,
      'blockHeight': instance.blockHeight,
    };
